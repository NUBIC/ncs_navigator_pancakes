A = DS.attr
HM = DS.hasMany

Pancakes.EventSearch = DS.Model.extend
  eventTypes: A 'string'
  scheduledStartDate: A 'string'
  scheduledEndDate: A 'string'
  dataCollectors: A 'string'
  studyLocations: HM 'Pancakes.StudyLocation'

  search: ->
    console.log 'searching', @get('scheduledStartDate'), @get('scheduledEndDate')

# vim:ts=2:sw=2:et:tw=78
