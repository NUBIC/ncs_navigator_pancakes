Pancakes.EventSearchesNewRoute = Ember.Route.extend
  setupController: (controller) ->
    controller.set 'content', Pancakes.EventSearch.createRecord()

    @controllerFor('studyLocations').setProperties
      editable: true
      command: controller.get 'content'

# vim:ts=2:sw=2:et:tw=78
