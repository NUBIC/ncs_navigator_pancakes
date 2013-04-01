Pancakes.Router.map ->
  @resource 'event_searches', ->
    @resource 'event_searches.show', path: '/:event_search_id'
    @route 'new'

Pancakes.Router.reopen
  location: 'history'

# vim:ts=2:sw=2:et:tw=78
