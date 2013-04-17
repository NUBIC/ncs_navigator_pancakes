# Pancakes.TagSelection implements the controller end of a tag selection
# mechanism.  It SHOULD be used with an Ember.ArrayController.  The objects in
# the ArrayController MUST have a label property.
#
# The label property is used for searching and display.
Pancakes.TagSelection = Ember.Mixin.create
  sortProperties: ['label']
  sortAscending: true

  candidates: (->
    term = @get('criterion')
    r = new RegExp(term, 'i')

    @get('arrangedContent').filter (et) ->
      r.test et.get('label')
  ).property('content.@each', 'criterion')

# vim:ts=2:sw=2:et:tw=78
