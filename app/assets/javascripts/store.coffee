#= require sjcl

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
  loadMany: (type, json, resp) ->
    serializer = @get 'serializer'

    for obj in json
      ref = serializer.referenceFor type, obj

      unless @references[ref]
        model = serializer.materialize(type, obj, resp)
        @references[ref] = model
        model.set 'isLoaded', true

      @references[ref]

  findAll: (type) ->
    _.tap Ember.A(), (arr) =>
      serializer = @get 'serializer'
      path = serializer.pathForType type
      root = serializer.pluralRootForType type

      $.getJSON(path)
        .done((json, status, resp) =>
          arr.replace 0, arr.length, @loadMany(type, json[root], resp)
        )
        .fail(->
          console.log "findAll #{type} failed"
        )

  findById: (id, type) ->
    _.tap type.create(), (m) =>
      serializer = @get 'serializer'
      path = serializer.pathForType type

      $.getJSON("#{path}/#{id}")
        .done((json, status, resp) ->
          serializer.deserializeOne(json, resp, type, m)
          m.set 'isLoaded', true
        )
        .fail(->
          console.log "findById #{type} failed"
        )

  generateId: ->
    # A v4 UUID requires 128 bits of random numbers; randomWords generates
    # 32-bit quantities.
    #
    # From RFC 4122, section 4.4:
    #  o  Set the two most significant bits (bits 6 and 7) of the
    #     clock_seq_hi_and_reserved to zero and one, respectively.
    #  o  Set the four most significant bits (bits 12 through 15) of the
    #     time_hi_and_version field to the 4-bit version number from
    #     Section 4.1.3.
    #  o  Set all the other bits to randomly (or pseudo-randomly) chosen
    #     values.
    #
    # To satisfy this, we start out with 128 bits' worth of random numbers,
    # then proceed in reverse order, twiddling what we need.
    words = sjcl.random.randomWords(4)
    words[1] = (words[1] & 0xFFFF0FFF) | 0x00004000
    words[2] = (words[2] & 0x3FFFFFFF) | 0x80000000
    x = sjcl.codec.hex.fromBits(words)
    "#{x.slice(0, 8)}-#{x.slice(8, 12)}-#{x.slice(12, 16)}-#{x.slice(16, 20)}-#{x.slice(20)}"

  save: (model) ->
    Ember.assert "You must set an ID on #{model} before you save it", model.get('id')

    serializer = @get 'serializer'
    type = model.constructor
    path = serializer.pathForType type
    data = {}
    id = model.get 'id'

    data[serializer.rootForType(type)] = model.serialize()

    $.ajax "#{path}/#{id}",
      type: 'PUT'
      contentType: 'application/json; charset=UTF-8'
      data: JSON.stringify data
      dataType: 'json'

Pancakes.store = Pancakes.Store.create
  serializer: Pancakes.Serializer.create
    plurals:
      event_search: 'event_searches'

# vim:ts=2:sw=2:et:tw=78
