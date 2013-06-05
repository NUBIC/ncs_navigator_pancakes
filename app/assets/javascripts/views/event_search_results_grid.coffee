#= require views/search_results_grid

# ----------------------------------------------------------------------------
# FORMATTERS AND SORTING
# ----------------------------------------------------------------------------

# Data collector formatter.
dcFormatter = (row, cell, value, columnDef, dataContext) ->
  value.join(', ')

# Event disposition formatter.
edFormatter = (row, cell, value, columnDef, dataContext) ->
  value['disposition']

# Event type formatter.
etFormatter = (row, cell, value, columnDef, dataContext) ->
  value['display_text']

# Participant formatter.
guard = (v) ->
  if v.toString().trim().length == 0
    '(empty)'
  else
    v

pFormatter = (row, cell, value, columnDef, dataContext) ->
  """
  <span class="name">#{guard dataContext['participant_first_name']}</span>
  <span class="name">#{guard dataContext['participant_last_name']}</span>
  <span class="participant-id">#{dataContext['participant_id']}</span>
  """

# Sort helpers.
fields = ['participant_first_name', 'participant_last_name', 'scheduled_date']

cmp = (a, b) ->
  if a < b
    -1
  else if a > b
    1
  else
    0

comparer = (a, b) ->
  ord = 0

  for field in fields
    ord += cmp(a[field], b[field])

  ord

# ----------------------------------------------------------------------------
# GRID
# ----------------------------------------------------------------------------

Pancakes.EventSearchResultsGrid = Pancakes.SearchResultsGrid.extend
  columns: [
    { id: 'data_collectors', name: 'Data collectors', field: 'data_collector_usernames', formatter: dcFormatter },
    { id: 'disposition', name: 'Disposition', field: 'disposition_code', formatter: edFormatter },
    { id: 'event_type', name: 'Event type', field: 'event_type', formatter: etFormatter },
    { id: 'participant', name: 'Participant', formatter: pFormatter },
    { id: 'scheduled_date', name: 'Scheduled date', field: 'scheduled_date' }
  ]

  groupOnContentChange: (->
    view = @get 'view'
    content = @get 'content'

    if view && content
      view.setGrouping([{ getter: 'group', formatter: (g) -> "Location: #{g.value}" }])
  ).observes('content', 'view')

  establishOrder: (->
    @get('view').onRowsChanged.subscribe (e, args) =>
      @get('view').sort comparer, true
  ).observes('view')

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
