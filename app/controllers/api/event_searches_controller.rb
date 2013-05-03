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
    @model.queue(current_user.pgt, 90.minutes)

    respond_with @model
  end

  def status
    e = EventSearch.find(params[:id])

    respond_with e.status
  end

  private

  def add_links
    response.headers['Link'] = [
      "<#{status_event_search_url(@model)}>; rel=status"
    ]
  end
end

# vim:ts=2:sw=2:et:tw=78
