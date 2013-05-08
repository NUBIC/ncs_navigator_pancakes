#= require slickgrid

Pancakes.SearchResultsGrid = Ember.View.extend
  didInsertElement: ->
    el = @$()

    @grid = new Slick.Grid el, [], [], {}

  willDestroyElement: ->
    @grid.destroy()

# vim:ts=2:sw=2:et:tw=78
