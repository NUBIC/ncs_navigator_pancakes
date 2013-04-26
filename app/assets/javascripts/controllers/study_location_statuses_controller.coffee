Pancakes.StudyLocationStatusesController = Ember.Controller.extend
	pollerId: null
	source: null

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
		$.ajax(@get('source.statusUrl'), 'GET')

# vim:ts=2:sw=2:et:tw=78
