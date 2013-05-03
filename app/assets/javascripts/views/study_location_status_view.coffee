Pancakes.StudyLocationStatusView = Ember.View.extend
  classNameBindings: ['standardClasses', 'status']

  standardClasses: ['query-status']

  status: (->
    url = @get 'location.url'
    statuses = @get 'statuses'

    statuses[url] if statuses && url
  ).property('location.url', 'statuses')

# vim:ts=2:sw=2:et:tw=78
