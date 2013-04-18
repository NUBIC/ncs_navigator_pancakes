Pancakes.EventSearchCriteriaController = Ember.ObjectController.extend
  needs: ['dataCollectors', 'eventTypes']

  # eventType{Criterion, Candidates} are attributes of the controller that
  # will later be manipulated with bindings; those attributes should not be
  # delegated by Ember.ObjectProxy.  We therefore initialize those attributes
  # here.
  eventTypeCriterion: null
  eventTypeCandidates: []
  dataCollectorCriterion: null
  dataCollectorCandidates: []

  # Now we can bind.
  eventTypeCriterionBinding: 'controllers.eventTypes.criterion'
  eventTypeCandidatesBinding: Ember.Binding.oneWay 'controllers.eventTypes.candidates'
  dataCollectorCriterionBinding: 'controllers.dataCollectors.criterion'
  dataCollectorCandidatesBinding: Ember.Binding.oneWay 'controllers.dataCollectors.candidates'

  canAddSelection: (content, item) ->
    true

  canRemoveSelection: (content, item) ->
    true

  addSelection: (content, item) ->
    content.addObject item

  removeSelection: (content, item) ->
    content.removeObject item

# vim:ts=2:sw=2:et:tw=78
