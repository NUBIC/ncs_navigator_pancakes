class Api::EventSearchesController < ApiController
  after_filter :add_links, :only => [:show, :update]

  def show
    @model = EventSearch.find(params[:id])

    respond_with @model
  end

  def update
    @model = EventSearch.find_or_initialize_by_uuid(params[:id])
    @model.json = params[:event_search]
    @model.save!

    respond_with @model
  end

  def status
    e = EventSearch.find(params[:id])

    respond_with e.status
  end

  def refresh
    e = EventSearch.find(params[:id])
    ttl = params[:ttl] ? [params[:ttl].to_i, 90.minutes].min : 90.minutes

    e.queue(current_user.pgt, ttl)

    render :json => ok, :status => :accepted
  end

  private

  def add_links
    response.headers['Link'] = [
      "<#{status_event_search_url(@model)}>; rel=status",
      "<#{refresh_event_search_url(@model)}>; rel=refresh"
    ]
  end
end

# vim:ts=2:sw=2:et:tw=78
