Pancakes.EventSearchesShowRoute = Ember.Route.extend
  # Here be dragons.
  openTransaction: (model) ->
    @txn = @get('store').transaction()
    @txn.add(model)

    # On commit, start a new transaction.
    model.one 'didCommit', =>
      Ember.assert 'Some records in the transaction failed to save', @txn.get('records.isEmpty')
      @openTransaction(model)

  # A state-management hack.  If we don't do this, Ember Data won't
  # perform the correct state transitions on associated records.
  mungeTransaction: (model, txn) ->
    model.eachRelationship (name, spec) =>
      model.get(name).forEach (m) =>
        @txn.add(m) if m.get('isDirty')

    # We don't care about the eachRelationship value.
    true

  setupController: (controller, model) ->
    @_super controller, model
    @openTransaction model

    @controllerFor('studyLocationStatuses').set 'source', model

    @controllerFor('studyLocations').setProperties
      editable: true
      command: controller.get 'content'

  events:
    submit: ->
      @mungeTransaction @get('controller.content')

      @txn.commit()

# vim:ts=2:sw=2:et:tw=78
