#= require jquery.ui.datepicker

Pancakes.DateField = Ember.TextField.extend
  attributeBindings: ['placeholder']

  didInsertElement: ->
    @$().datepicker()

# vim:ts=2:sw=2:et:tw=78
