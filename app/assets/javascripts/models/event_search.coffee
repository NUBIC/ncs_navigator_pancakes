A = DS.attr
HM = DS.hasMany

Pancakes.EventSearch = DS.Model.extend
  eventTypes: HM 'Pancakes.EventType'
  scheduledStartDate: A 'string'
  scheduledEndDate: A 'string'
  dataCollectors: HM 'Pancakes.DataCollector'
  studyLocations: HM 'Pancakes.StudyLocation'

# vim:ts=2:sw=2:et:tw=78
