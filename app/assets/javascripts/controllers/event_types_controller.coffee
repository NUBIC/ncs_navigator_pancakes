Pancakes.EventTypesController = Ember.ArrayController.extend
  candidates: (->
    term = @get('criterion')
    r = new RegExp(term, 'i')

    @get('content').filter (et) ->
      r.test et.get('display_text')
  ).property('content.@each', 'criterion')

# vim:ts=2:sw=2:et:tw=78
