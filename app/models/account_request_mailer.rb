class AccountRequestMailer < ActionMailer::Base
  def invitation req
    recipients req.email
    from UserSystem.user_messenger_from
    subject "Request to join account"
    body[:request] = req
  end

  def request req
    recipients req.account.administrators
    from UserSystem.user_messenger_from
    subject "Request to join account"
    body[:request] = req
  end
end
