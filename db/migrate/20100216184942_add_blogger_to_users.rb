class AddBloggerToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :blogger, :boolean, :default => true
  end

  def self.down
    remove_column :users, :blogger
  end
end
