class AddDescriptionToBlog < ActiveRecord::Migration
  def self.up
    add_column :users, :blog_description, :string
  end

  def self.down
    remove_column :users, :blog_description
  end
end
