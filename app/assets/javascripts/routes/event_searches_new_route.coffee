Pancakes.EventSearchesNewRoute = Ember.Route.extend
  activate: ->
    @txn = DS.get('defaultStore').transaction()

  setupController: (controller) ->
    search = @txn.createRecord Pancakes.EventSearch
    search.one 'didCommit', =>
      @transitionTo 'event_searches.show', search

    controller.set 'content', search

    @controllerFor('studyLocations').setProperties
      editable: true
      command: controller.get 'content'

  events:
    submit: ->
      @txn.commit()

# vim:ts=2:sw=2:et:tw=78
