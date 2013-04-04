Pancakes.EventSearchesNewController = Ember.ObjectController.extend
  needs: 'eventSearchCriteria'

  contentBinding: 'controllers.eventSearchCriteria.content'

# vim:ts=2:sw=2:et:tw=78
