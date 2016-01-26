class Feat < ActiveRecord::Base
  belongs_to :game
  belongs_to :profile

  @@login = 0
  cattr_accessor :login

  @@xp = 1
  cattr_accessor :xp

  @@score = 2
  cattr_accessor :score

  @@badge = 3
  cattr_accessor :badge

  @@rating = 4
  cattr_accessor :rating
  
  before_save :check_xp
  
  private
  
  # Make sure the constraints on xp and score are met before saving
  def check_xp
    if self.progress_type == Feat.xp
      # xp cannot be more than a 1000
      return false if self.progress > 1000
      
      # xp cannot go down
      last_xp = game.get_xp(prodile.id)
      return false if self.progress < last_xp
    end

    return true
  end
  
end
