##
# An account is a subscription mechanism that tracks users associated with the
# account and can do other accounting.
#
class Account < ActiveRecord::Base

  def self.increment_counter a, b
    if b.nil? and !caller.first.match(/replace.$/)
      logger.warn "INCREMENT_COUNTER: #{a}, #{b}"
      logger.warn caller.join("\n")
      logger.warn "\n"
    end
    super
  end

  belongs_to :account_type, :counter_cache => true
  has_many :users

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

  private
  def set_default_slug
    self.slug ||= self.name.downcase.gsub(/[^\w]+/, '-')
  end
end
