class AddRefusedByIdToPosts < ActiveRecord::Migration
  def self.up
    add_column :posts, :refused_by_id, :integer
    add_column :posts, :refused_text, :string, :limit => 200
  end

  def self.down
    remove_column :posts, :refused_by_id
  end
end
