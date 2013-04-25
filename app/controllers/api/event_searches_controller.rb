class Api::EventSearchesController < ApiController
  def update
    e = EventSearch.find_or_initialize_by_uuid(params[:id])
    e.json = params[:event_search]
    e.status_url = status_event_search_url(e)
    e.save!
    e.queue(current_user.pgt)

    render :json => e, :location => event_search_path(e.uuid)
  end

  def show
    e = EventSearch.find(params[:id])

    respond_with e
  end

  def status
    e = EventSearch.find(params[:id])

    respond_with e.status
  end
end

# vim:ts=2:sw=2:et:tw=78
