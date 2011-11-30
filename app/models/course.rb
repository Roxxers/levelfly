class Course < ActiveRecord::Base
  belongs_to :school
  has_many :participants, :as => :object
end
