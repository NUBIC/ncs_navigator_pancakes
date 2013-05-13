class Api::EventSearchesController < ApiController
  def show
    s = EventSearch.find(params[:id])

    respond_with s, :meta => links(s)
  end

  def create
    s = EventSearch.new
    s.id = SecureRandom.uuid
    s.json = params[:event_search]
    s.save!

    respond_with s, :meta => links(s)
  end

  def update
    s = EventSearch.find(params[:id])
    s.json = params[:event_search]
    s.save!

    respond_with s, :meta => links(s)
  end

  def status
    s = EventSearch.find(params[:id])

    respond_with s.status
  end

  def data
    s = EventSearch.find(params[:id])

    render :json => s.data
  end

  def refresh
    s = EventSearch.find(params[:id])
    ttl = params[:ttl] ? [params[:ttl].to_i, 90.minutes].min : 90.minutes

    s.queue(current_user.pgt, ttl)

    render :json => ok, :status => :accepted
  end

  private

  def links(model)
    { status: status_event_search_url(model),
      refresh: refresh_event_search_url(model),
      data: data_event_search_url(model)
    }
  end
end

# vim:ts=2:sw=2:et:tw=78
