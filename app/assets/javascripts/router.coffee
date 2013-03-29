Pancakes.Router.map ->
  @resource 'event_searches', ->
    @route 'new'
  @resource 'event_search', path: '/event_search/:event_search_id'

# vim:ts=2:sw=2:et:tw=78
