Pancakes.EventSearchesNewRoute = Ember.Route.extend
  model: ->
    Pancakes.EventSearch.create()

  setupController: (controller, model) ->
    controller.set 'content', model

    @controllerFor('studyLocations').setProperties
      editable: true
      command: controller.get 'content'

  deactivate: ->
    @controllerFor('studyLocations').set 'editable', false

  events:
    submit: ->
      search = @get 'controller.content'

      search.save().done(=>
        @transitionTo 'event_searches.show', search
      )

# vim:ts=2:sw=2:et:tw=78
