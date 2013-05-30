#= require slickgrid
#= require SlickGrid/slick.dataview
#= require SlickGrid/slick.groupitemmetadataprovider

Pancakes.SearchResultsGrid = Ember.View.extend
  columns: []
  classNames: ['grid']
  options: {}

  # Build up the SlickGrid elements.
  #
  # The grid is the only visual element here; the rest are for grouping,
  # sorting, and filtering.  They all fit in at view-level, though.
  didInsertElement: ->
    el = @$()
    groupItemMetadataProvider = new Slick.Data.GroupItemMetadataProvider

    view = new Slick.Data.DataView(
      groupItemMetadataProvider: groupItemMetadataProvider
      inlineFilters: true
    )

    @set 'view', view

    grid = new Slick.Grid el, @get('view'), @get('columns'), @get('options')

    @set 'grid', grid

    view.onRowCountChanged.subscribe (e, args) ->
      grid.updateRowCount()
      grid.render()

    view.onRowsChanged.subscribe (e, args) ->
      grid.invalidateRows(args.rows)
      grid.render()

    grid.autosizeColumns()
    grid.registerPlugin(groupItemMetadataProvider)

  # When this view is destroyed, destroy the grid and view also.
  willDestroyElement: ->
    @get('grid').destroy()
    @set 'grid', null
    @set 'view', null

# vim:ts=2:sw=2:et:tw=78
