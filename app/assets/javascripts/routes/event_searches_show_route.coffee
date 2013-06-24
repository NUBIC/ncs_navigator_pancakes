Pancakes.EventSearchesShowRoute = Ember.Route.extend
  renderTemplate: (controller, model) ->
    @_super controller, model

    @render 'studyLocationStatuses',
      into: 'application',
      outlet: 'studyLocationStatuses',
      controller: 'locationStatus'

  setupController: (controller, model) ->
    @_super controller, model

    @controllerFor('studyLocations').setProperties
      editable: true
      command: controller.get 'content'

  deactivate: ->
    @controllerFor('studyLocations').set 'editable', false

    @set 'controller.content', null

  events:
    submit: ->
      search = @get 'controller.content'

      search.save().done(=>
        @get('controller').refresh()
      )

# vim:ts=2:sw=2:et:tw=78
