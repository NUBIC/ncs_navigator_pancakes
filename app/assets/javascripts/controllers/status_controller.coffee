Pancakes.StatusController = Ember.ArrayController.extend
  command: null

  selectionBinding: 'command.studyLocations'

  setActiveBit: (->
    selection = @get 'selection'
    content = @get 'content'

    content.forEach (location) ->
      location.set 'active', selection?.contains(location)
  ).observes('content.@each', 'selection.@each')

# vim:ts=2:sw=2:et:tw=78
