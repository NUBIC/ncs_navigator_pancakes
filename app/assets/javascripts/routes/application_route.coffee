Pancakes.ApplicationRoute = Ember.Route.extend
  renderTemplate: (controller, model) ->
    @_super(controller, model)

    @render 'status',
      into: 'application',
      outlet: 'status',
      controller: 'status'

  setupController: (controller) ->
    @_super(controller)

    @controllerFor('status').setProperties
      editable: false
      selectByDefault: false
      available: Pancakes.StudyLocation.find()

# vim:ts=2:sw=2:et:tw=78
