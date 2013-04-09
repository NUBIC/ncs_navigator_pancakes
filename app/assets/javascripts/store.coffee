#= require adapter

Pancakes.Store = DS.Store.extend
  revision: 11
  adapter: Pancakes.Adapter.create()

# vim:ts=2:sw=2:et:tw=78
