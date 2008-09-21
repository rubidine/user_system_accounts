##
# An account is a subscription mechanism that tracks users associated with the
# account and can do other accounting.
#
class Account < ActiveRecord::Base

  belongs_to :account_type, :counter_cache => true
  has_many :users

  # don't let these attributes be assigned via web form bulk assigns
  attr_protected :last_payment_at, :next_payment_at

  # is the payment for this account late?
  def overdue?
    next_payment_at && next_payment_at.to_date < Date.today
  end

  # If an account is overdue to the point it gets shut off, it is suspended
  def suspended?
    next_payment_at \
    && (next_payment_at + UserSystem.account_grace_period).to_date < Date.today
  end
end
