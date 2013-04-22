class Api::EventSearchesController < ApiController
  def create
    e = EventSearch.create(:json => params[:event_search],
                           :username => current_user.username)

    respond_with e
  end
end
