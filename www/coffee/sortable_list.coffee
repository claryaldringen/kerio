
class Kerio.SortableList extends Kerio.Component

	constructor: (id, di, parent) ->
		super id, di, parent
		@issues = []
		@name = ''

	getElListId: -> @id + '_ul'

	setName: (@name) -> @

	add: (issue) ->
		@issues.push issue
		@

	save: (sort) ->
		@issues[index].priority = (sortedIndex+1) for issue, index in @issues when key.indexOf(issue.id) > -1 for key,sortedIndex in sort
		@

	saveResponse: (response, me) ->

	bindEvents: ->
		$('#' + @getElListId()).sortable connectWith: '.connected', update: (event, ui) => @save $('#' + @getElListId()).sortable 'toArray', {attribute: 'issueid'}


	getHtml: ->
		html = '<div class="title">' + @name + '</div><ul id="' + @getElListId() + '"'
		html += 'class="connected"' if @name in ['backlog','Sprint 1']
		html += '>'
		html += '<li class="issue" issueid="' + issue.id + '">' + issue.name + '</li>' for issue in @issues
		html += '</ul>'
