Pancakes.EventSearchesNewController = Ember.ObjectController.extend
  needs: ['eventSearchCriteria', 'status']

  contentBinding: 'controllers.eventSearchCriteria.content'

  allStudyLocations: (->
    @get('controllers.status.content')
  ).property('controllers.status.content.@each')

  enableStudyLocationsByDefault: (->
    locations = @get 'content.studyLocations'

    @get('allStudyLocations').forEach (location) ->
      locations.pushObject(location) unless locations.contains(location)
  ).observes('content', 'allStudyLocations')

# vim:ts=2:sw=2:et:tw=78
