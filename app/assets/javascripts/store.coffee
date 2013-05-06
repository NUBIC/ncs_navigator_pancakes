Pancakes.Store = Ember.Object.extend
  init: ->
    @_super.apply(this, arguments)

    @references = {}

  # Given a target type and JSON array of data, creates model instances of the
  # given type in the store.  There will be one instance of type created per
  # object in the array.
  #
  # Objects may only exist once in the store.  If JSON that would result in
  # two copies of a given object is loaded multiple times, only the object
  # from the first load will exist.
  #
  # Returns an array containing one model per JSON object.
  loadMany: (type, json) ->
    serializer = @get 'serializer'

    for obj in json
      ref = serializer.referenceFor type, obj

      unless @references[ref]
        model = serializer.materialize(type, obj)
        @references[ref] = model

      @references[ref]

  findAll: (type) ->
    _.tap Ember.A(), (arr) =>
      serializer = @get 'serializer'
      path = serializer.pathForType type
      root = serializer.pluralRootForType type

      $.getJSON(path)
        .done((json) =>
          arr.replace 0, arr.length, @loadMany(type, json[root])
        )
        .fail(->
          console.log "findAll #{type} failed"
        )

  findById: (id, type) ->
    _.tap type.create(), (m) =>
      serializer = @get 'serializer'
      path = serializer.pathForType type

      $.getJSON("#{path}/#{id}")
        .done((json) ->
          serializer.deserializeOne(json, type, m)
        )
        .fail(->
          console.log "findById #{type} failed"
        )

  save: (model) ->
    serializer = @get 'serializer'
    type = model.constructor
    path = serializer.pathForType type
    root = serializer.rootForType type
    data = {}
    method = 'POST'

    id = model.get 'id'

    if id
      path = "#{path}/#{id}"
      method = 'PUT'

    data[root] = model.serialize()

    $.ajax(path,
      type: method,
      contentType: 'application/json; charset=UTF-8'
      data: JSON.stringify data
    ).done((json) =>
      if json
        @get('serializer').deserializeOne(json, type, model)
    )

Pancakes.store = Pancakes.Store.create
  serializer: Pancakes.Serializer.create
    plurals:
      event_search: 'event_searches'

# vim:ts=2:sw=2:et:tw=78
