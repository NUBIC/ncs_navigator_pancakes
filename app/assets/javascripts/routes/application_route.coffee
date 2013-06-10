Pancakes.ApplicationRoute = Ember.Route.extend
  renderTemplate: (controller, model) ->
    @_super(controller, model)

    @render 'study_locations',
      into: 'application',
      outlet: 'studyLocations',
      controller: 'studyLocations'

  setupController: (controller) ->
    @_super(controller)

    @controllerFor('studyLocations').setProperties
      editable: false
      available: Pancakes.StudyLocation.find()

# vim:ts=2:sw=2:et:tw=78
