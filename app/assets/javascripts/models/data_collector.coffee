A = DS.attr

Pancakes.DataCollector = DS.Model.extend
  username: A 'string'
  firstName: A 'string'
  lastName: A 'string'

  fullName: (->
    {firstName: fn, lastName: ln} = @getProperties 'firstName', 'lastName'

    _.reject([fn, ln], (n) -> !n? || _.isEmpty(n.trim())).join(' ')
  ).property('firstName', 'lastName')

  label: (->
    "#{@get('username')} (#{@get('fullName')})"
  ).property('username', 'fullName')

# vim:ts=2:sw=2:et:tw=78
