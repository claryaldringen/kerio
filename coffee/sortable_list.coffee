
class Kerio.SortableList

	constructor: (@id, @di) ->
		@issues = []
		@name = ''

	setName: (@name) -> @

	load: ->
		@di.getRequest().addTask(@di.createTask('url', {}, @loadResponse, @)).send()
		@

	loadResponse: (response, me) ->
		response.issues.sort (prev, next) -> prev.priority - next.priority
		me.issues = response.issues
		me.render()

	save: (sort) ->
		@issues[index].priority = (sortedIndex+1) for issue, index in @issues when key.indexOf(issue.id) > -1 for key,sortedIndex in sort
		@

	saveResponse: (response, me) ->

	render: ->
		document.getElementById(@id).innerHTML = @getHtml()
		@bindEvents()
		@

	bindEvents: ->

	getHtml: ->
		html = '<div class="title">' + @name + '</div><ul>'
		html += '<li class="issue">' + issue.name + '</li>' for issue in @issues
		html += '</ul>'
