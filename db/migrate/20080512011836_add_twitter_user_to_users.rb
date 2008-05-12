class AddTwitterUserToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :twitter_user, :string
  end

  def self.down
    remove_column :users, :twitter_user
  end
end
