class Api::DataCollectorsController < ApiController
  def index
    respond_with Stores.data_collectors.all
  end
end
