class Api::EventSearchesController < ApiController
  def update
    e = EventSearch.find_or_initialize_by_uuid(params[:id])
    e.json = params[:event_search]
    e.save!

    render :nothing => true, :status => :no_content, :location => event_search_path(e.uuid)
  end
end
