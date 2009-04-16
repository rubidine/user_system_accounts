namespace :user_system_has_accounts do

  desc "Create a new Account Type"
  task :create_account_type do
    ac = AccountType.new
    AccountType.columns.collect(&:name).each do |key|
      if ENV[key.camelize]
        ac[key] = ENV[key.camelize]
      end
    end
    if ac.save
      puts "Created Account Type"
    else
      puts "Invalid account: #{ac.errors.full_messages.inspect}"
      puts "Provide attributes like: Duration=12 AllowedUsers=5"
    end
  end

  desc "Run migrations for the UserSystemHasAccounts Extension"
  task :migrate do
    require 'config/environment'
    ActiveRecord::Base.establish_connection
    require File.join(File.dirname(__FILE__), '..', 'ext_lib', 'plugin_migrator')
    ActiveRecord::PluginMigrator.migrate(File.join(File.dirname(__FILE__), '..', 'db', 'migrate'), ENV['VERSION'] ? ENV['VERSION'].to_i : nil)
  end

  desc 'Test the UserSystemHasAccounts Extension.'
  Rake::TestTask.new(:test) do |t|
    require 'config/environment'
    t.ruby_opts << "-r#{RAILS_ROOT}/test/test_helper"
    t.libs << File.join(File.dirname(__FILE__), '..', 'lib')
    t.pattern = File.join(File.dirname(__FILE__), '..', 'test/**/*_test.rb')
    t.verbose = true
  end

end
