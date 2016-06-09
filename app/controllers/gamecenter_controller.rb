class GamecenterController < ApplicationController
  layout 'main'
  before_filter :authenticate_user!, :except => [:status, :show, :connect, :authenticate, :get_current_user, :add_progress]

  def status
    message = "All OK"
    status = Gamecenter::SUCCESS
    
    render :text => { 'status' => status, 'message' => message }.to_json
  end

  # Login the player to GameCenter
  def authenticate
    message = ""
    status = Gamecenter::FAILURE
    data = {}
    
    user = User.find_by_email(params[:username])
    if user && user.valid_password?(params[:password])
      sign_out current_user
      sign_in user
      status = Gamecenter::SUCCESS
      profile = user.default_profile
      message = "#{profile.full_name} signed in"
      data = { 'alias' => profile.full_name, 'level' => profile.level, 'image' => profile.image_file_name, 'last_sign_in_at' => user.last_sign_in_at }
    end

    render :text => { 'status' => status, 'message' => message, 'user' => data }.to_json
  end
  
  def connect
    message = "Unknown error"
    status = Gamecenter::FAILURE
    data = {}
    
    handle = params[:handle]
    game = Game.find_by_handle(handle)
    if game
      message = "Connected to #{game.name}"
      status = Gamecenter::SUCCESS
      data = { 'name' => game.name, 'id' => game.id, 'player_count' => game.player_count }
    else
      message = "Game with handle #{handle} does not exist"
    end
    
    render :text => { 'status' => status, 'message' => message, 'game' => data }.to_json
  end
  
  # Returns the current user that was authenticated
  def get_current_user
    handle = params[:handle]
    message = ""
    status = Gamecenter::FAILURE
    user = {}
    score = 0
    xp = 0
    badges = []
    
    if current_user
      status = Gamecenter::SUCCESS
      profile = current_user.default_profile
      game = Game.find_by_handle(handle)
      score = game.get_score(profile.id)
      xp = game.get_xp(profile.id)
      badges = AvatarBadge.find(:all, :include => [:badge], :select => "id, badge_id", :conditions => ["profile_id = ? and badges.quest_id = ?", profile.id, game.id] ).collect { |x| { 'id' => x.badge.id, 'name' => x.badge.name, 'descr' => x.badge.descr, 'image' => "/images/badges/" + x.badge.badge_image.image_file_name } } # game specific?
      message = "#{profile.full_name} signed in"
      user = { 'alias' => profile.full_name, 'level' => profile.level, 'image' => profile.image_file_name, 'last_sign_in_at' => current_user.last_sign_in_at }
    end

    render :text => { 'status' => status, 'message' => message, 'user' => user, 'score' => score, 'xp' => xp, 'badges' => badges }.to_json
  end

  # Returns the list of top users by score
  def get_top_users
    handle = params[:handle]
    message = ""
    status = Gamecenter::FAILURE
    all_score = []
    
    if current_user
      status = Gamecenter::SUCCESS
      game = Game.find_by_handle(handle)
      all_score = game.get_all_scores_in_order
      message = "#{all_score.count} score records found"
    end

    render :text => { 'status' => status, 'message' => message, 'all_score' => all_score }.to_json
  end

  # Save a player's progress in a game
  def add_checkpoint
    handle = params[:handle]
    message = ""
    status = Gamecenter::FAILURE

    checkpoint = params[:checkpoint]

    if current_user
      status = Gamecenter::SUCCESS
      profile = current_user.default_profile
      game = Game.find_by_handle(handle)
      
      cp = Checkpoint.where(game_id: game.id, profile_id: profile.id).last

      if cp.nil?
        cp = Checkpoint.new
        cp.profile_id = profile.id
        cp.game_id = game.id
      end
      cp.checkpoint = checkpoint
      cp.save
      
      message = "Checkpoint #{cp.id} saved for #{game.name} for #{profile.full_name}"
    end
    
    render :text => { 'status' => status, 'message' => message }.to_json
  end
  
  def get_checkpoint
    handle = params[:handle]
    message = ""
    status = Gamecenter::FAILURE
    checkpoint = ""

    if current_user
      profile = current_user.default_profile
      game = Game.find_by_handle(handle)
      
      cp = Checkpoint.where(game_id: game.id, profile_id: profile.id).last
      
      if cp
        status = Gamecenter::SUCCESS
        message = "Found checkpoint #{cp.id} recorded on #{cp.updated_at}"
        checkpoint = cp.checkpoint
      end
    end
    
    render :text => { 'status' => status, 'message' => message, 'checkpoint' => checkpoint }.to_json
  end
  
  # Adds a player's progress to a game by creating a Feat record
  def add_progress
    handle = params[:handle]
    game = Game.find_by_handle(handle)
    if game.nil?
      message = "Game with handle #{handle} does not exist"
      status = Gamecenter::FAILURE

      render :text => { 'status' => status, 'message' => message }.to_json
      return
    end
    
    progress = params[:progress]
    progress_type = params[:progress_type]
    name = game.name
    addition = params[:add] == "true"
    unique = params[:unique] == "true"  # Unique badge?
    
    level = params[:level]  # May be nil
    profile_id = current_user.default_profile.id
    
    feat = Feat.new(:game_id => game.id, :profile_id => profile_id)
    feat.progress = progress
    feat.progress_type = progress_type
    feat.level = level

    message = "Progress recorded for game #{game.name} for user profile #{current_user.default_profile.id}."
    status = Gamecenter::SUCCESS

    # Check the value based on type
    case feat.progress_type
    when Feat.xp
      # Look up the last XP stored for the game. We will need to update the player's XP
      # with the difference
      last_xp = game.get_xp(profile_id)
      feat.progress += last_xp if addition
      if feat.progress <= 1000
        delta_xp = feat.progress - last_xp
        Feat.transaction do
          if delta_xp != 0
            profile = Profile.find(profile_id)
            profile.xp += delta_xp
            profile.save
          end
          feat.save
        end
      end
    when Feat.score
      if addition
        last_score = game.get_score(profile_id)
        feat.progress += last_score
      end
      Feat.transaction do
        feat.save
        Game.add_score_leader(feat)
      end
    when Feat.badge
      Feat.transaction do
        if feat.progress.blank?
          badge = Badge.find_create_game_badge(game.id, name, "New badge for #{game.name}")
          feat.progress = badge.id
        end
        save_feat = true
        if unique  # We only want to record this feat if the user already doesn't have this badge
          last_feat = Feat.where(progress_type: progress_type, progress: badge.id).first
          save_feat = false if last_feat
          message = "Duplicate badge. Progress not recorded for game #{game.name} for user profile #{current_user.default_profile.id}."
        end
        if save_feat
          # It's ok to receive the same badge more than once, unless the 'unique' parameter is used
          feat.save
          AvatarBadge.add_badge(profile_id, feat.progress)
        end
      end
    when Feat.rating
      feat.save if feat.progress.between?(1, 3)
    else
      feat.save
    end
    
    render :text => { 'status' => status, 'message' => message }.to_json
  end
  
  def add_game_badge
    handle = params[:handle]
    game = Game.find_by_handle(handle)
    if game.nil?
      message = "Game with handle #{handle} does not exist"
      status = Gamecenter::FAILURE

      render :text => { 'status' => status, 'message' => message }.to_json
      return
    end

    name = params[:name]
    descr = params[:descr]
    descr = "New badge for #{game.name}" if descr.blank?
    badge_image_id = params[:badge_image_id]

    @badge = Badge.find_create_game_badge(game.id, name, descr, badge_image_id)
  end
  
  def list_leaders
    @leaders = []
    
    handle = params[:handle]
    game = Game.find_by_handle(handle)
    return if game.nil?

    @leaders = GameScoreLeader.where(game_id: game.id).order("score desc")
  end
  
  def list_progress
    @feats = []

    handle = params[:handle]
    game = Game.find_by_handle(handle)
    return if game.nil?

    limit = params[:count]
    limit = 100 if limit.nil?

    profile_id = current_user.default_profile.id
    
    feat_list = Feat.select("progress_type, progress, level, created_at")
      .where(game_id: game.id, profile_id: profile_id)
      .order("created_at desc")
      .limit(limit)

    feat_list.each do |feat|
      case feat.progress_type
      when Feat.login
        @feats << "[#{feat.created_at}] #{current_user.default_profile.full_name} logged into #{game.name}"
      when Feat.xp
        @feats << "[#{feat.created_at}] #{current_user.default_profile.full_name} has a current XP of #{feat.progress}"
      when Feat.score
        @feats << "[#{feat.created_at}] #{current_user.default_profile.full_name} has a current score of #{feat.progress}"
      when Feat.badge
        badge = Badge.find_by_id(feat.progress)
        if badge
          @feats << "[#{feat.created_at}] #{current_user.default_profile.full_name} acquired #{badge ? badge.name : 'unknown'} badge"
        end
      when Feat.rating
        @feats << "[#{feat.created_at}] #{current_user.default_profile.full_name} acquired #{feat.progress} rating"
      when Feat.level
        @feats << "[#{feat.created_at}] #{current_user.default_profile.full_name}"
      else
        @feats << "[#{feat.created_at}] #{current_user.default_profile.full_name} received feat #{feat.progess} in #{feat.progress.type}"
      end
      @feats.last << " on #{feat.level}" if !feat.level.nil?
    end
  end
  
  # Returns 50 top scores for your game
  def list
    message = ""
    status = Gamecenter::SUCCESS
    
    render :text => { 'status' => status, 'message' => message }.to_json
  end

  # Update the player's progress in the game
  def update
    message = ""
    status = Gamecenter::SUCCESS
    
    render :text => { 'status' => status, 'message' => message }.to_json
  end

  # Returns the player's progress in the game
  def view
    message = ""
    status = Gamecenter::SUCCESS
    
    gc = Gamecenter.new
    
    render :text => { 'status' => status, 'message' => message, 'progress' => gc }.to_json
  end

  # web UI
  
  def index
    @profile = Profile.find(user_session[:profile_id])
    render :partial => "/gamecenter/list"
    @profile.record_action('last', 'gamecenter')
  end

  def show
    conditions = ["profiles.archived = ? and user_id is not null", false]
    @profiles = Profile.find(:all, :limit => 50,
      :conditions => conditions,
      :include => [:participants],
      :order => "xp desc")
    @game = Game.find(params[:id])
    @outcomes = @game.outcomes.limit(5)
    respond_to do |format|
      format.html {render :layout => 'public'}
    end
  end

  def get_rows
    session[:game_id] = nil
    @profile = Profile.find(:first, :conditions => ["user_id = ?", current_user.id])

    # filter is "active", "archived"
    filter = params[:filter]
    
    school_id = @profile.school_id
    school = School.find(school_id)
    conditions = ["games.handle is not null and school_id = ?", school_id]

    if filter == "active"
      conditions[0] += " and games.archived = ?"
      conditions << false
    elsif filter == "archived"
      conditions[0] += " and games.archived = ?"
      conditions << true
    end

    if @profile.role_name_id == 1 && filter == "active"
      user_feats = Feat.where(:profile_id => @profile.id).map(&:game_id)
      conditions[0] += " and id IN(?)"
      conditions << user_feats    
    end
    @games = Game.find(:all, :conditions => conditions, :order => "name")

    render :partial => "/gamecenter/rows"
  end
  
  def add_game
    @game = Game.new    
    @game.name = "Application Name"
    @game.descr = "Description"
    @game.last_rev = "v 1.0"
    @game.archived = false
    @game.published = false
    @game.school_id = current_user.profiles.first.school_id if current_user.profiles.present?
    1.upto(5) {|i| @game.outcomes.build}
    5.times do
      @game.screen_shots.build      
    end
    render :partial => "/gamecenter/form",locals: {url: gamecenter_save_game_path}
  end
  
  def save_game    
    @profile = Profile.find(:first, :conditions => ["user_id = ?", current_user.id])
    @game = Game.new(params[:game])
    @game.profile_id = @profile.id
    @game.save
    # render :json => { 'status' => 200, 'message' => 'Game created successfully' }
  end

  def edit_game
    @game = Game.find(params[:id])
    five_screens = 5 - @game.screen_shots.count
    five_screens.times do
      @game.screen_shots.build
    end

    session[:game_id] = @game.id
    render :partial => "/gamecenter/form",locals: {url: gamecenter_update_game_path(:id =>@game.id)}
  end

  def update_game
    params[:game].merge!("image" => params["file"]) if params["file"].present?
    @game = Game.find(params[:id]).update_attributes(params[:game])
    # render :text => { 'status' => 200, 'message' => 'Game updated successfully' }.to_json
  end

  def game_details
    @game = Game.find(params[:id])
    session[:game_id] = @game.id
    render :partial => "/gamecenter/game_details"
  end

  def download
    render :partial => "/gamecenter/download"
  end

  def support
    render :partial => "/gamecenter/support"
  end

  def achivements
    @game = Game.find(session[:game_id])    

    @profile = Profile.find(:first, :conditions => ["user_id = ?", current_user.id])
    if @profile.role_name_id == 1
      @feats = Feat.where(game_id: @game.id, profile_id: @profile.id).pluck(:progress)
      @badges = Badge.where(id: @feats)
    else
      @badges = Badge.where(:quest_id => @game.id)
    end

    render :partial => "/gamecenter/achivements"
  end 

  def leaderboard
    @game = Game.find(session[:game_id])
    
    @profiles_by_feats = Feat.where(game_id: @game.id).pluck(:profile_id).uniq
    profiles_temp = Profile.where(:id => @profiles_by_feats).order("xp desc")
    profiles_temp.each_with_index do |p,i|
      p[:rank] = i + 1
    end    
    @profiles = profiles_temp
    render :partial => "/gamecenter/leader_board"
  end

  def add_badge    
    @badge = Badge.new
    @badge_images = BadgeImage.where("image_file_name not in (?)","gold_badge.png").limit(48)
    render :partial =>"/gamecenter/add_game_badge", :locals=>{:profile_id=>current_user.id, :badge => @badge}
  end

  def edit_badge
    @badge = Badge.find(params[:id])
    @badge_images = BadgeImage.where("image_file_name not in (?)","gold_badge.png").limit(48)
    render :partial =>"/gamecenter/add_game_badge", :locals=>{:profile_id=>current_user.id, :badge => @badge}
  end

  def save_badge    
    # render :text => params and return false
    @profile = Profile.find(:first, :conditions => ["user_id = ?", current_user.id])    
    if params[:badge_id].present?
      @badge = Badge.find(params[:badge_id])
      if params[:badge_image].present? && !params[:available_badge_image_id].present?
        badge_image = @badge.badge_image
        badge_image.image = params[:badge_image]
        badge_image.save!
        @badge.available_badge_image_id = nil
      else
        @badge.badge_image_id = params[:available_badge_image_id]
        @badge.available_badge_image_id = params[:available_badge_image_id]
      end
      @badge.name = params[:name]
      @badge.descr = params[:descr]
      @badge.creator_profile_id = @profile.id
      message = 'Badge Updated'
    else params[:badge_image].present?
      if params[:available_badge_image_id].present?
        available_badge_image_id = params[:available_badge_image_id]
      else
        badge_image = BadgeImage.new()
        badge_image.image = params[:badge_image]
        badge_image.save!
      end
      @badge = Badge.new
      @badge.name = params[:name]
      @badge.descr = params[:descr]
      @badge.badge_image_id = badge_image.try(:id) || available_badge_image_id
      @badge.quest_id = session[:game_id]
      @badge.school_id = @profile.school_id
      @badge.creator_profile_id = @profile.id
      @badge.available_badge_image_id = available_badge_image_id
      message = 'Badge Created'
    end
    if @badge.save        
      render :json => {:status => true, :message => message}
    else
      render :json => {:status => false, :message => 'Something went wrong'}
    end
  end

end
