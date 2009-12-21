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

module UserModelHasAccount
  def self.included kls
    kls.send :before_validation, :denormalize_account_type
    kls.send :validate, :validate_account_has_space
    kls.send :after_create, :create_account_if_account_type_without_account

    kls.send :belongs_to, :account, :counter_cache => true
    kls.send :belongs_to, :account_type

    kls.send :named_scope, :sitewide_administrator, {:conditions => {:sitewide_administrator => true}}
    kls.send :named_scope, :account_administrator, {:conditions => {:account_administrator => true}}
    kls.send :named_scope, :for_account, lambda{|act| {:conditions => {:account_id => (act.is_a?(Account) ? act.id : act)}} }

    kls.send :attr_accessor, :new_account_name
    kls.send :attr_protected, :account_administrator
    kls.send :attr_protected, :sitewide_administrator
    kls.send :attr_protected, :account_id
  end

  def account_administrator?
    read_attribute(:account_administrator) || sitewide_administrator?
  end

  private
  def denormalize_account_type
    # force if account has changed
    if changes['account_id'] and account
      self.account_type = account.account_type
    end

    # default
    self.account_type ||= account.account_type if account

    true
  end

  def validate_account_has_space
    return true unless changes['account_id']
    return true unless account_type
    return true if account_type.unlimited_users?
    return true unless account
    # XXX race condition
    return true if (account_type.allowed_users - 1) > account.users_count
    errors.add(:account, 'has too many users')
    false
  end

  def create_account_if_account_type_without_account
    return true if account
    return true unless account_type
    return true if account_request_security_token

    self.account = Account.new
    # manually write attr_protected fields
    account.name = new_account_name
    account.account_type = account_type

    unless self.account.save
      if UserSystem.all_users_must_have_account
        errors.add(:account_name, "unable to create_account: #{account.errors.full_messages.inspect}")
        destroy
      end
      false
    else
      # This is an after create, so update manually, in the database
      # and in the current instance.
      # The account_id attribute must be set or counter_cache won't get updated.
      self.account_id = account.id
      self.account_administrator = true
      self.class.update_all(
        {:account_id => account.id, :account_administrator => true},
        {:id => id}
      )
      true
    end
  end

end
