class Post < ActiveRecord::Base
  belongs_to :user
  
  validates_presence_of :user_id
  
  def self.latest(query_options = {})
    with_scope(:find => {:conditions => {:state => 'published'}, :order => 'created_at DESC'} ) do
      find(:all, query_options)
    end
  end
  
  
  
end
