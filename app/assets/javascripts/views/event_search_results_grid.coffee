#= require views/search_results_grid

# Cell formatters.

# Data collector formatter.
dcFormatter = (row, cell, value, columnDef, dataContext) ->
  value.join(', ')

# Event disposition formatter.
edFormatter = (row, cell, value, columnDef, dataContext) ->
  value['disposition']

# Event type formatter.
etFormatter = (row, cell, value, columnDef, dataContext) ->
  value['display_text']

Pancakes.EventSearchResultsGrid = Pancakes.SearchResultsGrid.extend
  columns: [
    { id: 'data_collectors', name: 'Data collectors', field: 'data_collector_usernames', formatter: dcFormatter },
    { id: 'disposition', name: 'Disposition', field: 'disposition_code', formatter: edFormatter },
    { id: 'event_type', name: 'Event type', field: 'event_type', formatter: etFormatter },
    { id: 'participant_id', name: 'Participant ID', field: 'participant_id' },
    { id: 'scheduled_date', name: 'Scheduled date', field: 'scheduled_date' }
  ]

  groupOnContentChange: (->
    view = @get 'view'
    content = @get 'content'

    if view && content
      view.setGrouping([{ getter: 'group', formatter: (g) -> "Location: #{g.value}" }])

  ).observes('content', 'view')

  # The underlying DataView and GroupItemMetadataProvider have a couple of
  # requirements:
  #
  # 1. The DataView requires that each row's id property contain a unique ID.
  # 2. The grouping provider requires a top-level grouping member.
  # 
  # This observer builds both.
  rebuildIndices: (->
    view = @get 'view'
    content = @get 'content'

    if view && content
      data = content['event_searches']

      _.each data, (o) ->
        o['id'] = _.uniqueId()
        o['group'] = o['pancakes.location']['name']

      view.setItems data
  ).observes('content', 'view')

# vim:ts=2:sw=2:et:tw=78
