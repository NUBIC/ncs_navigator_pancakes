#= require models/data_collector

adapter = if window.location.search.lastIndexOf('fixture') != -1
            DS.FixtureAdapter.extend
              latency: 250
          else
            DS.RESTAdapter.configure 'plurals',
              event_search: 'event_searches'

            DS.RESTAdapter.extend
              namespace: 'api/v1'

Pancakes.Adapter = adapter

Pancakes.Adapter.map 'Pancakes.DataCollector',
  primaryKey: 'username'

# vim:ts=2:sw=2:et:tw=78
