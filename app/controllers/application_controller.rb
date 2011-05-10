class ApplicationController < ActionController::Base
  self.append_view_path("lib/big_tuna/hooks")
  protect_from_forgery

  include OptimisClient::AuthFilter
  before_filter RubyCAS::Filter
  before_filter :authorize, :except => :logout
  
  def authorize
    authorize_by_user_email(session[:cas_user], :ci, :manage)
  end

  def logout
    RubyCAS::Filter.logout(self)
  end
  
end
