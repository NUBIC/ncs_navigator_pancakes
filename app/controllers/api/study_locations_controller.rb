class Api::StudyLocationsController < ApiController
  def index
    respond_with StudyLocation.all
  end
end
