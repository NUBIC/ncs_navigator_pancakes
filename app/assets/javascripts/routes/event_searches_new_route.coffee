Pancakes.EventSearchesNewRoute = Ember.Route.extend
  setupController: (controller) ->
    statusController = @controllerFor 'status'

    controller.set 'content', Pancakes.EventSearch.createRecord()

    statusController.setProperties
      editable: true
      selectByDefault: true
      command: controller.get 'content'

# vim:ts=2:sw=2:et:tw=78
