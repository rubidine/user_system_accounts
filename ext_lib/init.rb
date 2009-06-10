# load Dispatcher if not present yet
unless defined?(ActionController) and defined?(ActionController::Dispatcher)
  require 'action_controller/dispatcher'
end

# Dependency reload mechanism
require File.join(File.dirname(__FILE__), 'user_system_has_accounts_dependency_extension')
ActiveSupport::Dependencies.extend UserSystemHasAccountsDependencyExtension

# copy in assets
if File.directory?(File.join(File.dirname(__FILE__), '..', 'public'))
  require 'fileutils'
  ['javascripts', 'stylesheets', 'images'].each do |type|
    r_path = File.join(RAILS_ROOT, 'public', type, 'user_system_has_accounts')
    p_path = File.join(File.dirname(__FILE__), '..', 'public', type)
    unless File.directory?(r_path)
      FileUtils.mkdir_p(r_path)
    end
    Dir["#{p_path}/*"].each do |asset|
      unless File.exist?(File.join(r_path, File.basename(asset)))
        FileUtils.cp_r(asset, r_path)
      end
    end
  end
end


