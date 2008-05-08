class AddTweetedToPosts < ActiveRecord::Migration
  def self.up
    add_column :posts, :tweeted_at, :datetime
    
    Post.update_all(:tweeted_at => Time.now)
  end

  def self.down
    remove_column :posts, :tweeted_at
  end
end
