class AddPublishedAtAndAuthorizedByIdToPosts < ActiveRecord::Migration
  def self.up
    add_column :posts, :published_at, :datetime
    add_column :posts, :authorized_by_id, :integer
  end

  def self.down
    remove_column :posts, :authorized_by_id
    remove_column :posts, :published_at
  end
end
