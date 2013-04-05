Pancakes.EventSearchCriteriaController = Ember.ObjectController.extend
  needs: 'eventTypes'

  # eventType{Criterion, Candidates} are attributes of the controller that
  # will later be manipulated with bindings; those attributes should not be
  # delegated by Ember.ObjectProxy.  We therefore initialize those attributes
  # here.
  eventTypeCriterion: null
  eventTypeCandidates: []

  # Now we can bind.
  eventTypeCriterionBinding: 'controllers.eventTypes.criterion'
  eventTypeCandidatesBinding: Ember.Binding.oneWay 'controllers.eventTypes.candidates'

  search: ->
    @get('content').search()

# vim:ts=2:sw=2:et:tw=78
