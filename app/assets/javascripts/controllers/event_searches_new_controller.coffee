Pancakes.EventSearchesNewController = Ember.ObjectController.extend
  needs: ['eventSearchCriteria', 'status']

  contentBinding: 'controllers.eventSearchCriteria.content'

  defaultToSelected: (->
    sc = @get 'controllers.status'

    sc.get('available').forEach (l) ->
      sc.select(l)
  ).observes('controllers.status.available.@each')

# vim:ts=2:sw=2:et:tw=78
