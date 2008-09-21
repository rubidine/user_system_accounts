# 'directory' is defined in rails plugin loading, and since we are eval'd
# instead of required, we get it here.  But radiant seems to require or load
# instead of eval, so work with it.  Also it can be defined as a function during
# migrations for some reason.
unless defined?(directory) == 'local-variable'
  directory = File.dirname(__FILE__)
end

# Load the extension mojo that hacks into the rails base classes.
require File.join(directory, 'ext_lib', 'init.rb')

# define some routes
ActionController::Routing::Routes.define_user_system_has_accounts_routes do |map|
  map.resources :account_types
end

ActiveSupport::Dependencies.register_user_system_has_accounts_extension do

  # associations, callbacks, etc for User model
  User.send :include, UserModelHasAccount

  # configuration
  UserSystem.extend UserSystemHasAccounts

  ViewExtender.register '/users/new/extra_fields',
                        'usha_user_new', 
                        {:partial => 'user_fields_for_account_type'}

end
