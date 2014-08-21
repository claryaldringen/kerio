
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

	bindEvents: ->
		child.bindEvents() for id,child of @children
