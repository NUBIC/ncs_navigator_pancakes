Pancakes.StudyLocationStatusView = Ember.View.extend
  classNameBindings: ['standardClasses', 'statusClasses']
  attributeBindings: ['title', 'name:data-location-name']
  standardClasses: ['status-view']

  statusClasses: (->
    switch @get('status')
      when 'success'
        'icon-ok success'
      when 'failure', 'error'
        'icon-exclamation-sign failure'
      when 'started'
        'icon-exchange working'
      else
        'blank'
  ).property('status')

  title: (->
    "#{@get('name')}: #{@get('status')}"
  ).property('name', 'status')

# vim:ts=2:sw=2:et:tw=78
