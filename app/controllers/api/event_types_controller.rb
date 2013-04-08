class Api::EventTypesController < ApiController
  def index
    respond_with EventType.all
  end
end
