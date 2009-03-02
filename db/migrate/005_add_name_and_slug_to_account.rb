class AddNameAndSlugToAccount < ActiveRecord::Migration
  def self.up
    add_column :accounts, :name, :string
    add_column :accounts, :slug, :string
  end

  def self.down
    remove_column :accounts, :name
    remove_column :accounts, :slug
  end
end
