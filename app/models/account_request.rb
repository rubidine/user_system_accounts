##
# An AccountRequest is a message from an account owner to a user or from a user
# to an account owner trying to link the two together.
#
class AccountRequest < ActiveRecord::Base

  belongs_to :account
  belongs_to :user

  validate :for_user_or_via_email

  before_create :set_security_token_if_via_email
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

  def send_invitation
    send_email
  end

  def new_security_token
    User.new.send(:generate_security_token)
  end

  def send_email
#    AccountInvitationMailer.deliver_invitation(self)
  end

end
