#= require models/model

Pancakes.EventSearch = Pancakes.Model.extend
  init: ->
    @_super.apply(this, arguments)

    @set 'dataCollectors', Ember.A() unless @get('dataCollectors')
    @set 'eventTypes', Ember.A() unless @get('eventTypes')
    @set 'studyLocations', Ember.A() unless @get('studyLocations')

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

  save: ->
    @get('store').save(this)

# vim:ts=2:sw=2:et:tw=78
