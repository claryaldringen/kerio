
class Kerio.ListItem extends Kerio.Component

	constructor: (id, di, parent) ->
		super id, di, parent
		@statusId = 2
		@issueId = null
		@name = ''
		@points = 0
		@remains = 0
		@issues = []
		@opened = no

	setStatusId: (@statusId) -> @

	getStatusId: -> @statusId

	setIssueId: (@issueId) -> @

	getIssueId: -> @issueId

	setName: (@name) -> @

	setPoints: (@points) -> @

	getPoints: ->
		points = 0
		if @issues.length then points += issue.getPoints() for issue in @issues else points = @points
		points * 1

	setRemains: (@remains) -> @

	getRemains: ->
		remains = 0
		if @issues.length then remains += issue.getRemains() for issue in @issues else remains = @remains
		remains * 1

	setSubtickets: (issues) ->
		if issues?
			@issues.push @di.createListItem(@id + '_' + issue.id, @).setIssueId(issue.id).setStatusId(issue.status_id).setName(issue.name).setPoints(issue.points).setRemains(issue.remains) for issue in issues
		@

	toggleOpen: ->
		@opened = not @opened
		@parent.render()

	savePoints: (points) ->
		@setPoints points
		@save().parent.render()

	saveRemains: (remains) ->
		@setRemains remains
		@save().parent.render()

	save: ->
		@di.getRequest().addTask(@di.createTask('/ajax/save-points', {id: @issueId, points: @points, remains: @remains}, @saveResponse, @)).send()
		@

	saveResponse: ->

	getFormated: (string) -> if string.length > 36 then string.substr(0, 36) + '...' else string

	bindEvents: ->
		super()
		$('#' + @id + ' .points').bind 'change', => @savePoints $('#' + @id + ' .points').val()
		$('#' + @id + ' .remains').bind 'change', => @saveRemains $('#' + @id + ' .remains').val()
		$('#' + @id + ' .open').bind 'click', => @toggleOpen()

	getHtml: ->
		points = 0
		remains = 0
		if @issues.length
			for issue in @issues
				points += issue.getPoints()
				remains += issue.getRemains()
		else
			points = @points
			remains = @remains
		html = ''
		html += '<div class="open">' + (if @opened then '-' else '+') + '</div>' if @issues.length
		html += '<span class="ticket ' + (if @issues.length then 'epic' else '') + '" title="' + @name + '">' + @getFormated(@name) + '</span>'
		html += '<input type="number" min="0" max="' + @points + '" class="hours remains" value="' + remains + '" ' + (if @issues.length then 'readonly' else '') + '>'
		html += '<input type="number" min="0" class="hours points" value="' + points + '" ' + (if @issues.length then 'readonly' else '') + '>'
		if @issues.length and @opened
			html += '<ul>'
			html += '<li id="' + issue.id + '" class="issue sub ' + (if issue.getStatusId() in [4,5] then 'ticket-done' else '') + '">' + issue.getHtml() + '</li>' for issue in @issues
			html += '</ul>'
		html