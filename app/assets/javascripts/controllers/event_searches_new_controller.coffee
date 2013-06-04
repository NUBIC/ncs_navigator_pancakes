Pancakes.EventSearchesNewController = Ember.ObjectController.extend
  needs: ['eventSearchCriteria', 'studyLocations']

  setupEditor: (->
    @set 'controllers.eventSearchCriteria.content', @get('content')
  ).observes('content')

  defaultToSelected: (->
    sc = @get 'controllers.studyLocations'

    sc.get('available').forEach (l) ->
      sc.select(l)
  ).observes('controllers.studyLocations.available.@each')

  setDefaultDateRange: (->
    start = moment()
    end = moment(start).add 'weeks', 6

    Ember.run =>
      @setProperties
        scheduledStartDate: start
        scheduledEndDate: end
  ).observes('content')

# vim:ts=2:sw=2:et:tw=78
