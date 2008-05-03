class Post < ActiveRecord::Base
  belongs_to :user
  
  validates_presence_of :user_id
  
  def self.latest
    find_all_by_state("published", :order => 'created_at DESC')
  end
end
