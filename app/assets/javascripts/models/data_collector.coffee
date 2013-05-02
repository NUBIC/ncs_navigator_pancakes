#= require models/model

Pancakes.DataCollector = Pancakes.Model.extend
  fullName: (->
    {firstName: fn, lastName: ln} = @getProperties 'firstName', 'lastName'

    _.reject([fn, ln], (n) -> !n? || _.isEmpty(n.trim())).join(' ')
  ).property('firstName', 'lastName')

  label: (->
    "#{@get('username')} (#{@get('fullName')})"
  ).property('username', 'fullName')

  deserialize: (doc) ->
    @setProperties
      id: doc['id']
      username: doc['username']
      firstName: doc['first_name']
      lastName: doc['last_name']

  serialize: ->
    id: @get 'id'
    username: @get 'username'
    first_name: @get 'firstName'
    last_name: @get 'lastName'

# vim:ts=2:sw=2:et:tw=78
