Pancakes.EventSearchesNewRoute = Ember.Route.extend
  setupController: (controller) ->
    controller.set 'content', Pancakes.EventSearch.createRecord()

# vim:ts=2:sw=2:et:tw=78
