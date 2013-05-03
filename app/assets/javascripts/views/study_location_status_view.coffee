Pancakes.StudyLocationStatusView = Ember.View.extend
  classNameBindings: ['standardClasses', 'status']

  standardClasses: ['query-status']

  status: (->
    url = @get 'location.url'
    statuses = @get 'statuses'

    if statuses && url
      switch statuses[url]
        when 'success'
          'icon-ok-sign success'
        when 'failure', 'error'
          'icon-exclamation-sign failure'
        when 'started'
          'icon-spinner icon-spin'
        else
          ''
  ).property('location.url', 'statuses')

# vim:ts=2:sw=2:et:tw=78
