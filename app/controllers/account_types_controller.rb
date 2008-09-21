class AccountTypesController < ApplicationController

  def index
    @account_types = AccountType.public.by_cost.find(:all)
  end

end
