Pancakes.EventSearchCriteriaController = Ember.ObjectController.extend
  search: ->
    @get('content').search()

# vim:ts=2:sw=2:et:tw=78
