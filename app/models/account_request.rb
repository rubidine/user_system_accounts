#
# An AccountRequest is a message from an account owner to a user or from a user
# to an account owner trying to link the two together.
#
class AccountRequest < ActiveRecord::Base

  belongs_to :account
  belongs_to :user

  after_create :send_email

  #
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
  def send_email
#    AccountInvitationMailer.deliver_invitation(self)
  end

end
