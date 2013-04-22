class Api::EventSearchesController < ApiController
  def create
    e = EventSearch.create(:json => params[:event_search],
                           :username => current_user.username)

    respond_with ok(e.id), :status => :created, :location => event_search_path(e.id)
  end
end
