class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.string   :title,          :null => false     
      t.string   :url,            :null => false
      t.text     :description,    :null => false
      t.integer  :user_id,        :null => false
      t.string   :state,          :null => false, :default => "pending"
      t.timestamps
    end
  end

  def self.down
    drop_table :posts
  end
end