# Displays study locations.  When a command (e.g. event search) is being
# prepared, also mediates the selection of study locations for that command.
Pancakes.StudyLocationsController = Ember.ArrayController.extend
  needs: ['studyLocationStatuses']
  available: []
  selectionBinding: 'command.studyLocations'
  sortAscending: true
  sortProperties: ['name']
  statuses: null
  statusesBinding: 'controllers.studyLocationStatuses.content'

  content: (->
    union = Ember.A []
    selection = @get 'selection'
    available = @get 'available'

    union.addObjects(selection) if selection?
    union.addObjects(available)
  ).property('available.@each', 'selection.@each')

  deselect: (location) ->
    @get('selection').removeObject location

  select: (location) ->
    @get('selection').addObject location

# vim:ts=2:sw=2:et:tw=78
