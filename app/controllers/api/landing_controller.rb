class Api::LandingController < ApiController
  def unknown
    respond_with error('Unknown action'), :status => :not_found
  end
end
