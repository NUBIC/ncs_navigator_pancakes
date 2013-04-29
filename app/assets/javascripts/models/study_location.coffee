#= require models/model

Pancakes.StudyLocation = Pancakes.Model.extend
  deserialize: (doc) ->
    @setProperties
      id: doc['id']
      name: doc['name']
      url: doc['url']

  serialize: ->
    id: @get 'id'
    name: @get 'name'
    url: @get 'url'

# vim:ts=2:sw=2:et:tw=78
