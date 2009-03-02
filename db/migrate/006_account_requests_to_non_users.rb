class AccountRequestsToNonUsers < ActiveRecord::Migration
  def self.up
    add_column :account_requests, :email, :string
    add_column :account_requests, :security_token, :string
  end

  def self.down
    remove_column :account_requests, :email
    remove_column :account_requests, :security_token
  end
end
