class UsersCanBeSitewideAdmins < ActiveRecord::Migration
  def self.up
    add_column :users, :sitewide_administrator, :boolean, :default => false
  end

  def self.down
    remove_column :users, :sitewide_administrator
  end
end
