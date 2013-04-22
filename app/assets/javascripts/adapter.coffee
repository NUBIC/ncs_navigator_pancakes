Pancakes.Adapter = DS.RESTAdapter.extend
  namespace: 'api/v1'

Pancakes.Adapter.configure 'plurals',
  event_search: 'event_searches'

Pancakes.Adapter.map 'Pancakes.EventType',
  primaryKey: 'local_code'

Pancakes.Adapter.map 'Pancakes.DataCollector',
  primaryKey: 'username'

Pancakes.Adapter.map 'Pancakes.StudyLocation',
  primaryKey: 'url'

Pancakes.Adapter.map 'Pancakes.EventSearch',
  eventTypes:
    embedded: 'always'
  dataCollectors:
    embedded: 'always'
  studyLocations:
    embedded: 'always'

# vim:ts=2:sw=2:et:tw=78
