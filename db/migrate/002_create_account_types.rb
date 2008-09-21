class CreateAccountTypes < ActiveRecord::Migration

  def self.up
    create_table :account_types do |t|
      t.string :name
      t.integer :duration
      t.integer :accounts_count, :default => 0
      t.integer :allowed_users
      t.integer :cost, :default => 0

      t.text :description

      # if it isn't public, not everyone can subscribe
      t.boolean :public, :default => true

      # default duration is in months, but we can be more dynamic
      t.boolean :duration_is_days, :duration_is_weeks, :unlimited_duration,
                :default => false
    end

    # for listing all public accounts sorted by cost
    add_index :account_types, [:public]
    add_index :account_types, [:cost]
    add_index :account_types, [:public, :cost]
  end

  def self.down
    drop_table :account_types
  end

end
