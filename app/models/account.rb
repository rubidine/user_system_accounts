##
# An account is a subscription mechanism that tracks users associated with the
# account and can do other accounting.
#
class Account < ActiveRecord::Base

  belongs_to :account_type, :counter_cache => true
  has_many :users
  has_many :account_requests
  has_many :administrators, :class_name => 'User', :conditions => {:account_administrator => true}

  # don't let any attributes be assigned via web form bulk assigns
  attr_accessible :name

  before_create :set_default_slug

  # is the payment for this account late?
  def overdue?
    next_payment_at && next_payment_at.to_date < Date.today
  end

  # If an account is overdue to the point it gets shut off, it is suspended
  def suspended?
    next_payment_at \
    && (next_payment_at + UserSystem.account_grace_period).to_date < Date.today
  end

  # print the name
  def to_s
    name.to_s
  end

  # check the difference in current users and max possible users
  def can_invite_users?
    account_type.unlimited_users? || users_count < account_type.allowed_users
  end

  private
  def set_default_slug
    self.slug ||= self.name.downcase.gsub(/[^\w]+/, '-')
  end
end
