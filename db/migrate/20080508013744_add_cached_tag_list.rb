class AddCachedTagList < ActiveRecord::Migration
  def self.up
    add_column :posts, :cached_tag_list, :string
  end
  def self.down
    remove_column :posts, :cached_tag_list, :string
  end
end
