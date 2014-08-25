
class Kerio.SortableList extends Kerio.Component

	constructor: (id, di, parent) ->
		super id, di, parent
		@issues = []
		@name = ''
		@listId = null
		@opened = no
		@milestone = ''
		@sortKey = 0

	getElUlId: -> @id + '_ul'

	setName: (@name) -> @

	getName: -> @name

	setListId: (@listId) -> @

	getListId: -> @listId

	setType: (@type) -> @

	setMilestone: (@milestone) -> @

	setOpened: (@opened) -> @

	setSortKey: (@sortKey) -> @

	getSortKey: -> @sortKey

	setIssue: (newIssue) ->
		return @ for issue in @issues when issue.id is newIssue.id
		@issues.push newIssue
		@

	save: (sort) ->
		@parent.setListToIssue(@, issueId).setPriorityToIssue(sortKey, issueId) for issueId, sortKey in sort
		@parent.save().balanceIssues()
		@

	rename: (name) ->
		@di.getRequest().addTask(@di.createTask('/ajax/rename-list', {id: @listId, name: name}, @saveResponse, @)).send()
		@

	switchType: ->
		@di.getRequest().addTask(@di.createTask('/ajax/switch-type', {id: @listId}, @saveResponse, @)).send()
		if @type is 'left' then @type = 'right' else @type = 'left'
		@parent.render()
		@

	toggle: ->
		if @opened then @opened = no else @opened = yes
		@di.getRequest().addTask(@di.createTask('/ajax/toggle', {id: @listId, opened: @opened}, @saveResponse, @)).send()
		@render()

	delete: ->
		@di.getRequest().addTask(@di.createTask('ajax/delete-list', {id: @listId}, @saveResponse, @)).send()
		@parent.clear().load()
		@

	saveResponse: ->

	bindEvents: ->
		$('#' + @getElUlId()).sortable connectWith: '.connected', update: (event, ui) => @save $('#' + @getElUlId()).sortable 'toArray', {attribute: 'issueid'}
		$('#' + @id + ' .switch-open').bind 'click', => @toggle()
		$('#' + @id + ' .title').bind 'change', => @rename $('#' + @id + ' .title').val()
		$('#' + @id + ' .switch-type').bind 'click', => @switchType()
		$('#' + @id + ' .delete').bind 'click', => @delete() if confirm 'Really delete?'
		@

	getHtml: ->
		html = '<div class="list-head" title="' + @milestone + '">'
		html += '<input type="text" class="title" value="' + @name+ '">'
		points = 0
		remains = 0
		for issue in @issues
			points += issue.getPoints()
			remains += issue.getRemains()
		html += '<span class="points">E: ' + points + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;R: ' + remains + '</span>'
		html += '</div>'
		if @opened
			html += '<ul id="' + @getElUlId() + '" class="connected">'
			html += '<li id="' + issue.id + '" class="issue ' + (if issue.getStatusId() in [4,5] then 'ticket-done' else '') + '" issueid="' + issue.getIssueId() + '">' + issue.getHtml() + '</li>' for issue in @issues
			html += '</ul>'
		html += '<div class="list-foot">'
		html += '<img src="images/arrow_' + (if @opened then 'up' else 'down') + '.png" title="' + (if @opened then 'Close' else 'Open') + '" class="action-icon switch-open">'
		html += '<img src="images/arrow_switch.png" title="Switch positions" class="action-icon switch-type">'
		html += '<img src="images/delete.png" title="Delete" class="action-icon delete">'
		html += '<a href="/homepage/scrumboard/' + @listId + '" class="scrum-board"><img src="images/arrow_right.png" title="Go to Scrum Board"></a>'
		html += '</div>'
