class AddCounterCacheToPosts < ActiveRecord::Migration
  def self.up
      add_column :users, :posts_count, :integer, :default => 0
      User.reset_column_information
      User.find(:all).each do |user|
        user.posts_count = user.posts.count
        user.save!
      end
    end

    def self.down
      remove_column :users, :posts_count
    end
end
