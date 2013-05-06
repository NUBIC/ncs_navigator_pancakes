Pancakes.EventSearchesShowController = Ember.ObjectController.extend
  needs: ['eventSearchCriteria', 'locationStatus']

  status: null
  statusBinding: 'controllers.locationStatus.status'

  setupEditor: (->
    @set 'controllers.eventSearchCriteria.content', @get('content')
  ).observes('content')

  # If the search hasn't started yet, start it up.
  getQueryStatus: (->
    return unless @get 'isLoaded'

    @updateStatus().done(=>
      @refresh() if !@get('isStarted')
    )
  ).observes('isLoaded')

  # If the search isn't done, poll for updates.
  waitForLoad: (->
    if @get('isLoaded') && !@get('isDone')
      @pollForUpdates()
  ).observes('isLoaded', 'isDone')

  refresh: ->
    @get('content').refresh().done(=> @updateStatus())

  pollForUpdates: ->
    if @get 'pollerId'
      window.clearInterval @get('pollerId')

    @set 'pollerId', window.setInterval((=>
      @updateStatus().done(=>
        if @get('isDone') || !@get('content')
          window.clearInterval @get('pollerId')
      )
    ), 1000)

  updateStatus: ->
    @get('content')?.updateStatus().done(=>
      @set 'status', @get('content.queries')
    )

# vim:ts=2:sw=2:et:tw=78
