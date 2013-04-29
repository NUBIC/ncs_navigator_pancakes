Pancakes.EventSearchesShowRoute = Ember.Route.extend
  setupController: (controller, model) ->
    @_super controller, model

    @controllerFor('studyLocationStatuses').set 'source', model

    @controllerFor('studyLocations').setProperties
      editable: true
      command: controller.get 'content'

  deactivate: ->
    @controllerFor('studyLocationStatuses').set 'source', null

  events:
    submit: ->
      search = @get 'controller.content'

      search.save().done(=>
        @transitionTo 'event_searches.show', search
      )

# vim:ts=2:sw=2:et:tw=78
