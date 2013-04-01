#= require jquery.ui.widget
#= require jquery.ui.autocomplete
#= require tag-it/js/tag-it

Pancakes.MultiSelect = Ember.TextField.extend
  attributeBindings: ['placeholder']

  didInsertElement: ->
    @$().tagit()

# vim:ts=2:sw=2:et:tw=78
