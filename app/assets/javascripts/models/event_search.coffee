#= require models/model

format = (prop) ->
  (->
    v = @get prop

    if moment.isMoment(v) && v.isValid()
      @set prop, v.format('YYYY-MM-DD')
  ).observes(prop)

Pancakes.EventSearch = Pancakes.Model.extend
  init: ->
    @_super.apply(this, arguments)

    @set 'dataCollectors', Ember.A() unless @get('dataCollectors')
    @set 'eventTypes', Ember.A() unless @get('eventTypes')
    @set 'studyLocations', Ember.A() unless @get('studyLocations')

  valid: (->
    @get('hasDateRange')
  ).property('hasDateRange')

  invalid: Ember.computed.not('valid')

  enforceStartDateAsString: format('scheduledStartDate')
  enforceEndDateAsString: format('scheduledEndDate')

  hasDateRange: (->
    @get('scheduledStartDate') || @get('scheduledEndDate')
  ).property('scheduledStartDate', 'scheduledEndDate')

  serialize: ->
    id: @get('id')
    scheduled_start_date: @get 'scheduledStartDate'
    scheduled_end_date: @get 'scheduledEndDate'
    data_collectors: @get('dataCollectors').map (o) -> o.serialize()
    event_types: @get('eventTypes').map (o) -> o.serialize()
    study_locations: @get('studyLocations').map (o) -> o.serialize()

  deserialize: (doc, meta) ->
    store = @get 'store'
    lookup = Ember.lookup
    get = Ember.get

    dcs = store.loadMany get(lookup, 'Pancakes.DataCollector'), doc['data_collectors']
    ets = store.loadMany get(lookup, 'Pancakes.EventType'), doc['event_types']
    sls = store.loadMany get(lookup, 'Pancakes.StudyLocation'), doc['study_locations']

    @setProperties
      id: doc['id']
      scheduledStartDate: doc['scheduled_start_date']
      scheduledEndDate: doc['scheduled_end_date']
      dataCollectors: dcs
      eventTypes: ets
      studyLocations: sls
      statusUrl: meta['status']
      refreshUrl: meta['refresh']
      dataUrl: meta['data']

  updateStatus: ->
    $.getJSON(@get 'statusUrl').done((json) =>
      @set 'isStarted', json['started']
      @set 'isDone', json['done']
      @set 'queries', json['queries']
    )

  refresh: ->
    $.ajax(@get('refreshUrl'), type: 'POST')

  save: ->
    @get('store').save(this)

  loadData: ->
    $.getJSON(@get 'dataUrl').done((json) =>
      @set 'reportData', json
    )

# vim:ts=2:sw=2:et:tw=78
