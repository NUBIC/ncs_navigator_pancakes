#= require jquery.ui.widget
#= require jquery.ui.autocomplete
#= require tag-it/js/tag-it

Pancakes.MultiSelect = Ember.TextField.extend
  showAutocompleteChoices: (->
    if @get('showChoicesCallback') && @get('candidates')
      cb = @get('showChoicesCallback')

      cb(@get('candidates').mapProperty 'display_text')
  ).observes('candidates.@each', 'showChoicesCallback')

  didInsertElement: ->
    @$().tagit
      autocomplete:
        delay: 0
        source: (search, showChoices) =>
          @set 'showChoicesCallback', showChoices
          @set 'criterion', search.term

# vim:ts=2:sw=2:et:tw=78
