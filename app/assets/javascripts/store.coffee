#= require adapter

Pancakes.Store = DS.Store.extend
  revision: 11
  adapter: Pancakes.Adapter.create()
