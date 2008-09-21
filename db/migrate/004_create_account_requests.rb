class CreateAccountRequests < ActiveRecord::Migration
  def self.up
    create_table :account_requests do |t|
      t.integer :user_id, :account_id
      t.boolean :approved_by_account, :approved_by_user, :default => false
      t.timestamp :rejected_by_account_at, :rejected_by_user_at
      t.string :message, :response
    end
  end

  def self.down
    drop_table :account_requests
  end
end
