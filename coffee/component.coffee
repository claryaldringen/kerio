
class Kerio.Component

	constructor: (@id, @di, @parent = null) ->
		@children = {}
		@parent?.children[@id] = @

	render: ->
		document.getElementById(@id).innerHTML = @getHtml()
		@bindEvents()
		@

	bindEvents: ->
		child.bindEvents() for id,child of @children
