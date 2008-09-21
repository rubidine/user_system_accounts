class CreateAccounts < ActiveRecord::Migration
  def self.up
    create_table :accounts do |t|
      t.integer :account_type_id
      t.integer :users_count, :default => 0
      t.timestamp :last_payment_at
      t.timestamp :next_payment_at
    end
  end

  def self.down
    drop_table :accounts
  end
end
