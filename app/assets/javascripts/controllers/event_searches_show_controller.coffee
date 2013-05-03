Pancakes.EventSearchesShowController = Ember.ObjectController.extend
  needs: 'eventSearchCriteria'

  setupEditor: (->
    @set 'controllers.eventSearchCriteria.content', @get('content')
  ).observes('content')

# vim:ts=2:sw=2:et:tw=78
