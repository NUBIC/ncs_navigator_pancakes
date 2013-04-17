Pancakes.EventSearchesRoute = Ember.Route.extend
  renderTemplate: (controller, model) ->
    @_super controller, model

    @render 'event_searches/criteria',
      into: 'event_searches',
      outlet: 'criteria',
      controller: 'eventSearchCriteria'

  setupController: (controller) ->
    @_super controller

    @controllerFor('eventTypes').set 'content', Pancakes.EventType.find()
    @controllerFor('dataCollectors').set 'content', Pancakes.DataCollector.find()

# vim:ts=2:sw=2:et:tw=78
