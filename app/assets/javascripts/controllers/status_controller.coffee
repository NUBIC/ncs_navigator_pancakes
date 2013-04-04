# Displays study locations.  When a command (e.g. event search) is being
# prepared, also mediates the selection of study locations for that command.
Pancakes.StatusController = Ember.ArrayController.extend
  available: []
  selectionBinding: 'command.studyLocations'
  sortAscending: true
  sortProperties: ['name']

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

  onDefault: (->
    if @get('selectByDefault') && @get('command')
      @get('available').forEach (l) =>
        @select l
  ).observes('available.@each', 'selectByDefault', 'command')

# vim:ts=2:sw=2:et:tw=78
