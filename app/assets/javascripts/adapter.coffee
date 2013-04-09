adapter = if window.location.search.lastIndexOf('real') != -1
            DS.RESTAdapter.extend
              namespace: 'api/v1'
          else
            DS.FixtureAdapter.extend
              latency: 250

Pancakes.Adapter = adapter

# vim:ts=2:sw=2:et:tw=78
