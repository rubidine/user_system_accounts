##
# An account type is a type of subscription an account holder can subscribe
# to to add users at this account level.
# 
class AccountType < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name

  fixed_point_field :cost

  named_scope :public, :conditions => {:public => true}
  named_scope :by_cost, :order => 'cost'

  # Does this account allow any number of users to join its ranks?
  def unlimited_users?
    allowed_users.nil?
  end

end
