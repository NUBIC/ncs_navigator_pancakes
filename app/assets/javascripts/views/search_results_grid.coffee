#= require slickgrid

Pancakes.SearchResultsGrid = Ember.View.extend
  columns: []

  options: {}

  didInsertElement: ->
    el = @$()

    @grid = new Slick.Grid el, @get('content'), @get('columns'), @get('options')

  willDestroyElement: ->
    @grid.destroy()

# vim:ts=2:sw=2:et:tw=78
