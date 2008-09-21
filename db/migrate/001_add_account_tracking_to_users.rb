class AddAccountTrackingToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :account_id, :integer
    add_column :users, :account_type_id, :integer
    add_column :users, :account_administrator, :boolean
  end

  def self.down
    remove_column :users, :account_id
    remove_column :users, :account_type_id
    remove_column :users, :account_administrator
  end
end
