Pancakes.LocationStatusController = Ember.ArrayController.extend
  needs: ['studyLocations']

  locationsBinding: 'controllers.studyLocations.arrangedContent'

  content: (->
    status = @get 'status'

    @get('locations').map (l) ->
      status[l.get('url')] if status
  ).property('locations.@each', 'status')

# vim:ts=2:sw=2:et:tw=78
