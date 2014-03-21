module ApplicationHelper
 include MessageHelper
 
 def is_a_valid_email(email)
  
  r= Regexp.new(/\b[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}\b/)
	if email.scan(r).uniq.length>0
    #if len.length>0
    return true 
	else
    return false
  end
 end
  
 def change_date_format(date)
    if not date.blank?
      date.strftime("%m-%d-%Y")
    else
      ''
    end
  end
  
  def change_date_time_format(date)
    if not date.blank?
      date.strftime("%m-%d-%Y %I:%M %p")
    else
      ''
    end
  end 
  
  def notification_badge(profile)
    recently_messaged = profile.recently_messaged
    return false if recently_messaged.count > 0 && recently_messaged.first.unread_message_count.to_i > 0

    recently_messaged = Message.active.involving(profile.id).find(
      :all, 
      :joins => :message_viewers,
      :conditions => {
        :messages => {
          :message_type => 'Message',
          :target_type => 'Profile',
          :parent_type => 'Profile'
        },
        :message_viewers => {
          :viewer_profile_id => profile.id
        }
      }
    )

    profile_ids = []
    recently_messaged.map do |r|
      profile_ids.push(r.profile_id)
      profile_ids.push(r.parent_id)
    end
    profile_ids.uniq!
    profile_ids.delete(profile.id)

    messages_viewed(profile_ids, profile.id).count == 0
  end
	
	def formatted_html_content(content)
		return auto_link(content.gsub(/\n/, '<br/>').html_safe) unless content.nil?
	end
  
  def school
    if session[:school_id]
      School.find(session[:school_id])
    elsif current_user && current_user.default_school
      session[:school_id] = current_user.default_school.id
      current_user.default_school
    else
      School.find_by_handle("demo")
    end
  end
  
  def current_profile
    Profile.find_by_user_id_and_school_id(current_user.id, school.id)
  end
end
