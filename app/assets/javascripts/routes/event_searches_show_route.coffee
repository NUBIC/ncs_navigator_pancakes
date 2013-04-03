Pancakes.EventSearchesShowRoute = Ember.Route.extend
  setupController: (controller) ->
    @_super controller

    statusController = @controllerFor 'status'

    statusController.setProperties
      editable: true
      command: controller.get 'content'

# vim:ts=2:sw=2:et:tw=78
