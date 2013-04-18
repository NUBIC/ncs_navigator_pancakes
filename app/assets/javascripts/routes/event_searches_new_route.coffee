Pancakes.EventSearchesNewRoute = Ember.Route.extend
  activate: ->
    @txn = DS.get('defaultStore').transaction()

  setupController: (controller) ->
    controller.set 'content', @txn.createRecord(Pancakes.EventSearch)

    @controllerFor('studyLocations').setProperties
      editable: true
      command: controller.get 'content'

  events:
    submit: ->
      @txn.commit()

# vim:ts=2:sw=2:et:tw=78
