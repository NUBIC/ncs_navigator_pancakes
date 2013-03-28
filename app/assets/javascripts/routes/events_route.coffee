Pancakes.EventsRoute = Ember.Route.extend
  renderTemplate: ->
    @render 'events'

    @render 'status',
      into: 'events',
      outlet: 'status',
      controller: 'status'

    @render 'events/report',
      into: 'events',
      outlet: 'report',
      controller: 'report'

  setupController: ->
    @controllerFor('status').set 'content', Pancakes.CasesInstance.find()

# vim:ts=2:sw=2:et:tw=78
