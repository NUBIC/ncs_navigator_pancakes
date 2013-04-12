class ApplicationController < ActionController::Base
  include Aker::Rails::SecuredController

  protect_from_forgery
end
