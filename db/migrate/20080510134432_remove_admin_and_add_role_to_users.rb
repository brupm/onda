class RemoveAdminAndAddRoleToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :role, :string, :limit => 6, :default => "writer" #admin or editor    
    User.update_all("role = 'admin'", "admin = 1")    
    remove_column :users, :admin
  end

  def self.down
    add_column :users, :admin, :boolean, :default => false
    User.update_all("admin = 1", "role = 'admin'")
    remove_column :users, :role
  end
end
