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

##
# An account is a subscription mechanism that tracks users associated with the
# account and can do other accounting.
#
class Account < ActiveRecord::Base

  belongs_to :account_type, :counter_cache => true
  has_many :users
  has_many :administrators,
           :class_name => 'User',
           :conditions => {:account_administrator => true}

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
