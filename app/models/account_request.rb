##
# An AccountRequest is a message from an account owner to a user or from a user
# to an account owner trying to link the two together.
#
class AccountRequest < ActiveRecord::Base

  belongs_to :account
  belongs_to :user

  validate :for_user_or_via_email

  before_create :set_security_token_if_via_email
  before_create :set_approved_by_account_if_via_email
  after_create :send_invitation


  # don't let a form automatically approve the merger
  attr_protected :approved_by_account, :approved_by_user,
                 :rejected_by_account_at, :rejected_by_user_at

  ##
  # Look up an account by an administrator's email address and set account_id.
  # Since we know this is initiated by a user, it is automatically approved
  # by the user.
  #
  def administrator_email= eml
    u = User.account_administrator.find_by_email(eml)
    return unless u
    self.account_id = u.account_id
    self.approved_by_user = true
  end

  def dummy_user_model
    User.new(
      :login => email.match(/(^[^@]+)/)[1],
      :email => email,
      :account_id => account_id
    )
  end

  private
  def via_email?
    email
  end

  def for_user_or_via_email
    unless via_email? or user
      errors.add(:email, "specify an email or user account")
    end
    true
  end

  def set_security_token_if_via_email
    self.security_token = new_security_token if via_email?
    true
  end

  def set_approved_by_account_if_via_email
    self.approved_by_account = true if via_email?
    true
  end

  def send_invitation
    if via_email?
      email_invitation
    else
      email_request
    end
  end

  def new_security_token
    User.new.send(:generate_security_token)
  end

  def email_invitation
    AccountRequestMailer.deliver_invitation(self)
  end

  def email_request
    AccountRequestMailer.deliver_request(self)
  end

end
