
class Kerio.SortableList extends Kerio.Component

	constructor: (id, di, parent) ->
		super id, di, parent
		@issues = []
		@name = ''
		@listId = null

	getElListId: -> @id + '_ul'

	setName: (@name) -> @

	getName: -> @name

	setListId: (@listId) -> @

	getListId: -> @listId

	setIssue: (newIssue) ->
		return @ for issue in @issues when issue.id is newIssue.id
		@issues.push newIssue
		@

	save: (sort) ->
		@parent.setListToIssue(@, issueId).setPriorityToIssue(sortKey, issueId) for issueId, sortKey in sort
		@parent.save().balanceIssues()
		@

	bindEvents: ->
		$('#' + @getElListId()).sortable connectWith: '.connected', update: (event, ui) => @save $('#' + @getElListId()).sortable 'toArray', {attribute: 'issueid'}


	getHtml: ->
		html = '<div class="title">' + @name + '</div><ul id="' + @getElListId() + '" class="connected">'
		html += '<li class="issue" issueid="' + issue.id + '">' + issue.name + '</li>' for issue in @issues
		html += '</ul>'
