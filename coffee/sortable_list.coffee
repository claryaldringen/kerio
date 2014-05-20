
class Kerio.SortableList extends Kerio.Component

	constructor: (@id, @di, parent) ->
		@issues = []
		@name = ''

	setName: (@name) -> @

	add: (issue) ->
		@issues.push issue
		@

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
