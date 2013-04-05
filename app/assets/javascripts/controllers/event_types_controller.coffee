Pancakes.EventTypesController = Ember.ArrayController.extend
  sortProperties: ['display_text']
  sortAscending: true

  candidates: (->
    term = @get('criterion')
    r = new RegExp(term, 'i')

    @get('arrangedContent').filter (et) ->
      r.test et.get('display_text')
  ).property('content.@each', 'criterion')

# vim:ts=2:sw=2:et:tw=78
