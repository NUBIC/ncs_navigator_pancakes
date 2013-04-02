#= require adapter
#= require local_adapter

Pancakes.Store = DS.Store.extend
  revision: 11
  adapter: Pancakes.Adapter.create()

Pancakes.LocalStore = DS.Store.extend
  revision: 11
  adapter: Pancakes.LocalAdapter.create()

Pancakes.localStore = Pancakes.LocalStore.create()

# vim:ts=2:sw=2:et:tw=78
