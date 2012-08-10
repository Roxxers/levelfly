class Role < ActiveRecord::Base
  
  @@create_group = 'create_group'
  cattr_accessor :create_group
  
  @@create_task = 'create_task'
  cattr_accessor :create_task
  
  @@create_course = 'create_course'
  cattr_accessor :create_course
  
  @@edit_grade = 'edit_grade'
  cattr_accessor :edit_grade
  
  @@edit_user = 'edit_user'
  cattr_accessor :edit_user
  
  def self.set_user_role(profile_id)
    user_role = Role.find(:first, :conditions => ["profile_id = ? and (name = ? or name = ?)", profile_id,Role.create_group,Role.create_task])
    if user_role.nil?
       Role.create(:profile_id => profile_id, :name =>Role.create_group)
       Role.create(:profile_id => profile_id, :name =>Role.create_task)       
    end  
  end
  
  def self.check_permission(profile_id,type)
    @permission = []
    Role.where("profile_id = ?",profile_id).each do |role|
      if (type == "G" and role.name == Role.create_group)
        return true
        break
      elsif(type == "T" and role.name == Role.create_task)
        return true
        break
      elsif(type == "C" and role.name == Role.create_course)
        return true
        break
      elsif(type==Role.edit_grade and role.name == Role.edit_grade)
        return true
        break
      elsif(type==Role.edit_user and role.name == Role.edit_user)
        return true
        break  
      end
    end
  return false  
  end
  
end