A = DS.attr

Pancakes.EventSearch = DS.Model.extend
  eventTypes: A 'string'
  scheduledStartDate: A 'string'
  scheduledEndDate: A 'string'
  dataCollectors: A 'string'

# vim:ts=2:sw=2:et:tw=78
