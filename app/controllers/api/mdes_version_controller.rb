class Api::MdesVersionController < ApiController
  before_filter :require_development

  def set
    Pancakes::Application.mdes_version = params[:mdes_version]

    respond_with ok
  end

  def require_development
    unless Rails.env.test? || Rails.env.development?
      respond_with error('Incorrect environment'), :status => :bad_request
    end
  end
end
