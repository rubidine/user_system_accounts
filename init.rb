# 'directory' is defined in rails plugin loading, and since we are eval'd
# instead of required, we get it here.  But radiant seems to require or load
# instead of eval, so work with it.  Also it can be defined as a function during
# migrations for some reason.
unless defined?(directory) == 'local-variable'
  directory = File.dirname(__FILE__)
end

# Load the extension mojo that hacks into the rails base classes.
require File.join(directory, 'ext_lib', 'init.rb')

ActiveSupport::Dependencies.register_user_system_has_accounts_extension do

  # associations, callbacks, etc for User model
  User.send :include, UserModelHasAccount

  # configuration
  UserSystem.extend UserSystemHasAccounts

  # login filters
  ApplicationController.send :include, UserSystemHasAccountsLoginFilters
  ApplicationController.send :prepend_before_filter, :ensure_account_user_match

  # start sessions based on subdomain
  SessionsController.send :include, UserSystemHasAccountsSessionsController

  # redirects for invalid users
  UserRedirect.send :include, UserSystemHasAccountsUserRedirect
  UserRedirect.send :on_redirection, :join_account
  UserRedirect.send :on_redirection, :renew_account

  # view extensions
  ViewExtender.register '/users/new/form_body',
                        :top,
                        'usha_user_new', 
                        {:partial => 'users/user_fields_for_account_type'}
  ViewExtender.register '/users/new/form_contents',
                        :bottom,
                        'usha_account_request_field', 
                        {:partial => 'users/user_fields_for_account_request'}

end
