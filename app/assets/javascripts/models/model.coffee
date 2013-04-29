get = Ember.get
store = Ember.computed ->
  Pancakes.store

Pancakes.Model = Ember.Object.extend
  store: store

Pancakes.Model.reopenClass
  store: store

  find: ->
    if arguments.length == 0
      get(this, 'store').findAll this
    else if arguments.length == 1 && typeof(arguments[0]) == 'string'
      get(this, 'store').findById arguments[0], this

# vim:ts=2:sw=2:et:tw=78
