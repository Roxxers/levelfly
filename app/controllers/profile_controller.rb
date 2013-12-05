class ProfileController < ApplicationController
  layout 'main'
  before_filter :authenticate_user!
  
  def index
    @profile = Profile.find(user_session[:profile_id])
    if params[:search_text]
      search_text =  "%#{params[:search_text]}%"
      @profiles = Profile.find(:all, :conditions=>["school_id = ? and lower(full_name) LIKE ? and user_id is not null",@profile.school_id, search_text.downcase], :order => "full_name")
    end
    respond_to do |wants|
      wants.html do
        if request.xhr?
          render :partial => "/profile/people"
        else
          render
        end
      end
    end
  end

  def show
    if params[:id].blank?
      @profile = Profile.find(:first, :conditions => ["user_id = ?", current_user.id])
      publish_profile(@profile)
    else
      @profile = Profile.find(params[:id])
    end
    
    new_profile = nil
    
    if @profile.nil?
      school_id = school.id
      if user_session[:profile_id].blank?
        new_profile = Profile.find(:first, :conditions => ["code = ? and school_id = ?", "DEFAULT", school_id], :include => [:avatar])
      else
        @profile = Profile.find_by_id(user_session[:profile_id])
        if @profile.nil?
          new_profile = Profile.find(:first, :conditions => ["code = ? and school_id = ?", "DEFAULT", school_id], :include => [:avatar])
        end
      end
    end
    
    if new_profile
      @profile = Profile.create_for_user(current_user.id,school.id)
      publish_profile(@profile)
    end
    
    render :text => {"profile"=>@profile, "avatar"=>@profile.avatar, "new_profile"=>new_profile, "major"=>@profile.major, "school"=>@profile.school}.to_json
  end

  def edit
    profile = Profile.find(user_session[:profile_id])
    ids = profile.sports_reward   
    wardrobe_items = WardrobeItem.find(:all, 
      :conditions => ["archived = ? and wardrobe_id in (?)", false, ids],
      :order => "depth, sort_order")
    
    render :text => wardrobe_items.to_json
  end
  
  def save_meta
    id = params[:id]
    profile = params[:profile]
    @profile = Profile.find(id)

    #@profile.full_name = profile["full_name"]
    @profile.major_id = profile["major_id"]
    @profile.school_id = profile["school_id"]
    @profile.interests = profile["interests"]
    @profile.contact_info = profile["contact_info"]
    @profile.save
    
    publish_profile(@profile)
    
    render :text => {"profile"=>@profile}.to_json
  end
  
  def save_notes
    id = params[:id]
    @profile = Profile.find(id)
    Note.delete_all(["profile_id = ? and about_object_id = ? and about_object_type = 'Profile'",user_session[:profile_id],@profile.id])
    if !params[:notes].blank?
      new_note = Note.new
      new_note.profile_id = user_session[:profile_id]
      new_note.about_object_id = @profile.id
      new_note.about_object_type = "Profile"
      new_note.content = params[:notes]
      new_note.save
    end
    render :text => {"profile"=>@profile}.to_json
  end
  
  def save
    id = params[:id]
    profile = params[:profile]
    avatar = params[:avatar]
    if profile["code"] == "DEFAULT"
      # Save a new profile
      @profile = Profile.new
      @avatar = Avatar.new
    else
      @profile = Profile.find(id)
      @avatar = @profile.avatar
    end

    #@profile.full_name = profile["full_name"]
    @profile.major_id = profile["major_id"]
    @profile.school_id = profile["school_id"]
    @profile.user_id = current_user.id if current_user
    @profile.save
    
    @avatar.skin = avatar["skin"]
    @avatar.background = avatar["background"]
    @avatar.body = avatar["body"]
    @avatar.hat_back = avatar["hat_back"]
    @avatar.hair_back = avatar["hair_back"]
    @avatar.shoes = avatar["shoes"]
    @avatar.bottom = avatar["bottom"]
    @avatar.necklace = avatar["necklace"]
    @avatar.top = avatar["top"]
    @avatar.head = avatar["head"]
    @avatar.earrings = avatar["earrings"]
    @avatar.facial_marks = avatar["facial_marks"]
    @avatar.facial_hair = avatar["facial_hair"]
    @avatar.face = avatar["face"]
    @avatar.glasses = avatar["glasses"]
    @avatar.hair = avatar["hair"]
    @avatar.hat = avatar["hat"]
    @avatar.prop = avatar["prop"]
    @avatar.profile_id = @profile.id
    @avatar.save
    
    if @avatar.save
     file_name = "avatar_#{@profile.updated_at}.jpg"
     @profile.image_file_name = "https://s3.amazonaws.com/#{ENV['S3_PATH']}/avatar_thumb/avatar_#{@profile.updated_at}.jpg"
     @profile.save
     Attachment.aws_upload(@profile.school_id, file_name, Base64.decode64(params[:avatar_img]), true)
   end
    publish_profile(@profile)
    
    render :text => {"profile"=>@profile, "avatar"=>@avatar}.to_json
  end
  
  def accept_code
    render :partial => "/profile/code_dialog"
  end

  def change_name
    render :partial => "/profile/name_dialog"
  end
  
  def change_major
    @majors = Major.find(:all, 
      :conditions => ["archived = ?", false],
      :order => "name")
    render :partial => "/profile/major_dialog"
  end
  
  def validate_code
    code = params[:code].to_s.upcase
    access_code = AccessCode.find_by_code(code)
    major = nil
    school = nil
    if access_code
      major = access_code.major
      school = access_code.school
    end
    render :text => {"major"=>major, "school"=>school}.to_json
  end
  
  def user_profile
    previous_level = nil
    if params[:profile_id].blank?
      @profile = Profile.find(user_session[:profile_id])
      @badge = Badge.badge_count(@profile.id)
    else
      @profile = Profile.find(params[:profile_id])
      @badge = Badge.badge_count(@profile.id)
      notes = Note.find(:first, :conditions =>["profile_id = ? and about_object_id = ? and about_object_type = 'Profile'",user_session[:profile_id], @profile.id])
      if !notes.nil?
        @notes = notes.content
      end
    end
    previous_level = @profile.level
    @current_friends = @profile.friends
    @groups = Course.all_group(@profile,"M")
    @courses = Course.course_filter(@profile.id,"")
    @major = Major.find(:all, :conditions =>["school_id = ? ",@profile.school_id])
    #@level = Reward.find(:first, :conditions=>["xp <= ? and object_type = 'level'",  @profile.xp], :order=>"xp DESC")
    #puts"#{@level.inspect}"
    #@profile.level = @level.object_id
    #@profile.save
    @levels = Reward.find(:all, :select => "distinct xp", :conditions=>["object_type = 'level'"], :order=>"xp ASC").collect(&:xp)
    if(previous_level != @profile.level)
      content = "Congratulations! You have achieved level #{@profile.level}."
      Message.send_notification(@profile.id,content,@profile.id)
    end  
    render :partial => "/profile/user_profile", :locals => {:profile => @profile}
  end

  def edit_wardrobe
    if params[:profile_id].blank?
      @profile = Profile.find(user_session[:profile_id])
    else
      @profile = Profile.find(params[:profile_id])
    end
    render :partial => "/profile/edit_wardrobe", :locals => {:profile => @profile}
  end
  
  def account_setup
    if params[:id] && !params[:id].nil?
      @current_user = Profile.find(params[:id])
      render :partial => "profile/account_setup"
    end
  end
  
  def change_password
    if params[:id] and not params[:id].nil?
      @user = User.find(params[:id])
      @user.email = params[:email] if params[:email]
      if params[:password] and !params[:password].blank?
        @user.password = params[:password]
      end
      if @user.save
        profile = Profile.find(user_session[:profile_id])
        profile.full_name = params[:full_name]
        profile.save
        sign_in(@user, :bypass => true)
        render :json =>{:text =>"Account detail changed successfully",:status =>true}
      else
        render :json =>{:text =>"ERROR",:status =>false}
      end
    end
  end

end
