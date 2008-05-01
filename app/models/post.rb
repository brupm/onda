class Post < ActiveRecord::Base
  def self.latest
    find_all_by_state("published", :order => 'created_at DESC')
  end
end
