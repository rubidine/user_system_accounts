module UserSystemHasAccountsDependencyExtension

  def self.extended kls
    kls.class_eval do
      def register_user_system_has_accounts_extension &blk
        if blk
          ActionController::Dispatcher.to_prepare :user_system_has_accounts, &blk
        end
      end
    end
  end

end
