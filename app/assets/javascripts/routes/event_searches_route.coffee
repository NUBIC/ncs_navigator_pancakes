Pancakes.EventSearchesRoute = Ember.Route.extend
  renderTemplate: (controller, model) ->
    @_super controller, model

    @render 'event_searches/criteria',
      into: 'event_searches',
      outlet: 'criteria',
      controller: 'eventSearchCriteria'

# vim:ts=2:sw=2:et:tw=78
