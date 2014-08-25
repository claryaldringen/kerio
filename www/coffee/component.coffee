
class Kerio.Component

	constructor: (@id, @di, @parent = null) ->
		@children = {}
		@parent?.children[@id] = @
		@events = {}

	render: ->
		document.getElementById(@id).innerHTML = @getHtml()
		@bindEvents()
		@

	getEvent: (eventName) ->
		@events[eventName] = new Kerio.Event() if not @events[eventName]?
		@events[eventName]

	addOpacity: ->
		$('#' + @id).addClass 'opacity'
		@

	removeOpacity: ->
		$('#' + @id).removeClass 'opacity'
		@

	bindEvents: ->
		child.bindEvents() for id,child of @children
