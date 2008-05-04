class AddNickAndUrlToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :nick, :string, :limit => 15
    add_column :users, :url, :string, :limit => 100
  end

  def self.down
    remove_column :users, :url
    remove_column :users, :nick
  end
end
