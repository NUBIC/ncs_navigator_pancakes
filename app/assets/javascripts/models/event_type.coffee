#= require models/model

# An EventType represents an entry in the EVENT_TYPE_CL1 MDES code list.
Pancakes.EventType = Pancakes.Model.extend
  labelBinding: 'displayText'

  deserialize: (doc) ->
    @setProperties
      id: doc['id']
      localCode: doc['local_code']
      displayText: doc['display_text']

  serialize: ->
    id: @get 'id'
    local_code: @get 'localCode'
    display_text: @get 'displayText'

# vim:ts=2:sw=2:et:tw=78
