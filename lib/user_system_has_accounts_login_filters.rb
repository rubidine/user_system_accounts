# Copyright (c) 2008 Todd Willey <todd@rubidine.com>
# 
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
# 
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

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

  def require_sitewide_administrator_login
    if require_user_login and current_user.sitewide_administrator?
      true
    else
      render :template => 'users/requires_sitewide_admin', :status => 403
      false
    end
  end

  def current_account
    @usys_account = current_user.account if current_user
    @usys_account
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
