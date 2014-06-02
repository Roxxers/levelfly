class Message < ActiveRecord::Base
  belongs_to :profile
  belongs_to :parent, :polymorphic => true
  belongs_to :target, :polymorphic => true
  belongs_to :wall
  has_many :message_viewers

  scope :starred, :conditions => ['starred = ?', true]
  scope :active, :conditions => {:archived => [false, nil]}
  scope :involving, lambda {|profile_id| where('profile_id = ? or parent_id = ?', profile_id, profile_id)}
  scope :interesting, :conditions => ["(message_type = 'Message' and target_type = 'Profile' and parent_type = 'Profile') or parent_type = 'Message'"]

  scope :between, (lambda do |ids, id2|
    snippets = ids.map do |id|
      "((parent_id = :other and profile_id = :current_user) or (parent_id = :current_user and profile_id = :other))".gsub(/:other/, "#{id}")
    end

    where(snippets.join(' or '), {:current_user => id2})
  end)

  def self.send_friend_request(profile_id,parent_id,wall_id,target_id)
    @message = Message.new
    @message.profile_id = profile_id
    @message.parent_id = parent_id
    @message.target_id = target_id
    @message.target_type = "Course"
    @message.parent_type = "Course"
    @message.message_type = "course_invite"
    @message.content = "I'd like to be your friend. Please accept my invite."
    @message.wall_id = Wall.get_wall_id(parent_id, "Course") 
    @message.archived = false
    @message.post_date = DateTime.now
    @message.save
    return @message
  end

  def self.send_course_request(profile_id, parent_id, wall_id, target_id,section_type,message_type,content)
    course = Course.find(target_id)
    @message = Message.new
    @message.profile_id = profile_id
    @message.parent_id = parent_id
    @message.target_id = target_id
    @message.target_type = section_type
    @message.parent_type = section_type
    @message.message_type = message_type
    @message.content = content
    @message.wall_id = wall_id#Wall.get_wall_id(parent_id, "Course")
    @message.archived = false
    @message.post_date = DateTime.now
    @message.save
    MessageViewer.invites(profile_id, @message.id,parent_id)
    return @message
  end

  def self.send_school_invitations(user, sender)
    @message = Message.new
    @message.parent = @message.profile = sender
    @message.target = sender.school
    @message.message_type = 'school_invite'
    @message.content = "Please join #{sender.school.code} (#{sender.school.name})"
    @message.archived = false
    @message.post_date = DateTime.now
    @message.save

    user.profiles.each do |profile|
      MessageViewer.create(
        :message_id => @message.id,
        :poster_profile_id => sender.id,
        :viewer_profile_id => profile.id,
        :archived => false,
        :viewed => false
      )
    end
  end

  def self.respond_to_course_invitation(parent_id,profile_id,target_id,content,section_type)
    course = Course.find(target_id)
    @message = Message.new
    @message.profile_id = parent_id
    @message.parent_id = profile_id
    @message.target_id = target_id
    # Needs the wall id for the recipient
    @message.target_type = section_type
    @message.parent_type = "Profile"
    @message.message_type = "Message"
    @message.content = content
    @message.archived = false
    @message.post_date = DateTime.now
    @message.save
    MessageViewer.invites(parent_id, @message.id,profile_id)
    return @message
  end
  
  def formatted_content
     return self.content.gsub(/\n/, '<br/>').html_safe
  end
  
  def self.send_notification(current_user,content,profile_id)
    @message = Message.new
    @message.profile_id = current_user
    @message.parent_id = profile_id
    @message.target_type = "Notification"
    @message.parent_type = "Profile"
    @message.message_type = "Message"
    # @message.content = "Congratulation! You have achieved level #{level}"
    @message.content = content;
    @message.archived = false
    @message.post_date = DateTime.now
    @message.save
    MessageViewer.invites(current_user, @message.id,profile_id)
  
  end

  def self.save_message(current_profile,parent,parent_type,content,message_type,course = nil)
    wall_id = Wall.get_wall_id(parent.id, parent_type)
    message = Message.new
    message.profile_id = current_profile.id
    message.parent_id = parent.id
    message.parent_type = parent_type 
    message.content = content
    message.target_id = parent.id
    message.target_type = parent_type
    message.message_type = message_type
    message.wall_id = wall_id
    message.post_date = DateTime.now
    
    if message.save
      MessageViewer.add(current_profile.id,message.id,parent_type,parent.id)
      UserMailer.private_message(parent.user.email,current_profile,current_profile.school,content).deliver unless course
      UserMailer.course_private_message(parent.user.email,current_profile,current_profile.school,course,content).deliver if course
      feed = Feed.find(:first,:conditions=>["profile_id = ? and wall_id = ?",current_profile.id,wall_id])
      if feed.nil?
        Feed.create(:profile_id => current_profile.id,:wall_id =>wall_id)
      end
    end
  end

end
