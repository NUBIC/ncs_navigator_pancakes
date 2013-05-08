Pancakes.Serializer = Ember.Object.extend
  pluralize: (word) ->
    @pluralFor(word) || "#{word}s"

  pluralFor: (word) ->
    ps = @get 'plurals'
    ps[word] if ps

  # Stolen from Ember Data.
  rootForType: (type) ->
    typeString = type.toString()

    Ember.assert "Your model must not be anonymous. It was " + type, typeString.charAt(0) != '('

    parts = typeString.split(".")
    name = parts[parts.length - 1]
    name.replace(/([A-Z])/g, '_$1').toLowerCase().slice(1)

  pluralRootForType: (type) ->
    @pluralize @rootForType(type)

  pathForType: (type) ->
    "/api/v1/#{@pluralRootForType(type)}"

  referenceFor: (type, json) ->
    "#{type}:#{json['id']}"

  materialize: (type, json) ->
    _.tap type.create(), (m) =>
      @deserialize m, json

  deserializeOne: (json, type, m) ->
    root = @rootForType type
    @deserialize m, json[root], json['meta']

  deserialize: (m, json, meta) ->
    m.deserialize json, meta
    m.set 'isLoaded', true

# vim:ts=2:sw=2:et:tw=78
