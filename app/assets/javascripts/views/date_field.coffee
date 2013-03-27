#= require jquery.ui.datepicker

Pancakes.DateField = Ember.TextField.extend
  attributeBindings: ['type']
  type: 'date'

  didInsertElement: ->
    @$().datepicker() unless Modernizr.inputtypes.date

# vim:ts=2:sw=2:et:tw=78
