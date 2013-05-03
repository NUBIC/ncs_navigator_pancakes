Pancakes.StudyLocationStatusesController = Ember.Controller.extend
	pollControl: (->
		id = @get 'pollerId'
		m = @get 'source'

		if id
			window.clearInterval(id)
			@set 'pollerId', null

		if m
			@set 'pollerId', window.setInterval _.bind(@poller, this), 1000
	).observes('source')

	poller: ->
    $.getJSON(@get 'source.statusUrl').done((json) =>
      @set 'content', json
    )

# vim:ts=2:sw=2:et:tw=78
