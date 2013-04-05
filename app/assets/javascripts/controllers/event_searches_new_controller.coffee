Pancakes.EventSearchesNewController = Ember.ObjectController.extend
  needs: ['eventSearchCriteria', 'studyLocations']

  contentBinding: 'controllers.eventSearchCriteria.content'

  defaultToSelected: (->
    sc = @get 'controllers.studyLocations'

    sc.get('available').forEach (l) ->
      sc.select(l)
  ).observes('controllers.studyLocations.available.@each')

# vim:ts=2:sw=2:et:tw=78
