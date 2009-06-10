module UserSystemHasAccountsLoginFilters
  private
  def self.included kls
    kls.send :extend, ClassMethods
    kls.send :helper_method, :current_account
  end

  def require_account_administrator_login
    if require_user_login and current_user.account_administrator?
      true
    else
      render :template => 'users/requires_account_admin', :status => 403
      false
    end
  end

  def require_sistewide_administrator_login
    if require_user_login and current_user.sitewide_administrator?
      true
    else
      render :template => 'users/requires_sitewide_admin', :status => 403
      false
    end
  end

  def current_account
    @usys_account = current_user.account if current_user
    @usys_account ||= Account.find_by_slug(subdomain_key) if subdomain_key
    @usys_account
  end

  def subdomain_key
    request.subdomains.first
  end

  def ensure_account_user_match
    if current_account and current_user and current_user.account != current_account
      raise AccountMismatchError, "User: #{current_user.account}/#{current_account}"
    end
  end

  module ClassMethods
    def only_for_account_administrator options={}
      before_filter(options) do |inst|
        inst.send(:require_account_administrator_login)
      end
    end

    def only_for_sitewide_administrator options={}
      before_filter(options) do |inst|
        inst.send(:require_sitewide_administrator_login)
      end
    end
  end
end
