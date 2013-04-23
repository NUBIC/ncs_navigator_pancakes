class Api::EventSearchesController < ApiController
  def update
    e = EventSearch.find_or_initialize_by_uuid(params[:id])
    e.json = params[:event_search]
    e.save!

    e.queue

    render :nothing => true, :status => :no_content, :location => event_search_path(e.uuid)
  end

  def show
    e = EventSearch.find(params[:id])

    respond_with e
  end
end

# vim:ts=2:sw=2:et:tw=78
