
class Kerio.ListFactory extends Kerio.Component

	BACKLOG_ID = 1

	constructor: (id, di, parent) ->
		super id, di
		@issues = []
		@lists = {}
		@changed = no

	getHtml: ->

	clear: ->
		@issues = []
		@lists = {}
		@

	load: ->
		@di.getRequest().addTask(@di.createTask('/ajax/load-stories', {}, @loadResponse, @)).send()
		@

	getLists: -> @lists

	loadResponse: (response) ->
		@issues = response.issues
		@changed = yes;
		@balanceIssues()

	save: ->
		@di.getRequest().addTask(@di.createTask('/ajax/save-stories', @issues, @saveResponse, @)).send()
		@

	saveResponse: (response, me) ->

	balanceIssues: ->
		@issues.sort (prev, next) -> prev.priority - next.priority
		if @changed
			list.issues = [] for list_sort_key, list of @lists
			for issue in @issues
				if not @lists[issue.list_sort_key]?
					@lists[issue.list_sort_key] = @di.createList(@id + '_' + issue.list_id, @).setName(issue.list_name).setListId(issue.list_id).setType(issue.list_type).setMilestone(issue.list_milestone).setOpened(issue.list_opened).setSortKey(issue.list_sort_key)
				if issue.id?
					@lists[issue.list_sort_key].setIssue @di.createListItem('list_item_' + issue.id, @).setIssueId(issue.id).setStatusId(issue.status_id).setName(issue.name).setPoints(issue.points).setRemains(issue.remains).setSubtickets(issue.subtickets) if issue.id?
			@changed = no
			@render()
		@

	setListToIssue: (list, issueId) ->
		for issue,i in @issues when issue.id is issueId*1 and issue.list_id isnt list.getListId()
			@issues[i].list_name = list.getName()
			@issues[i].list_id = list.getListId()
			@issues[i].list_sort_key = list.getSortKey()
			@changed = yes
		@

	setPriorityToIssue: (priority, issueId) ->
		@issues[i].priority = priority for issue,i in @issues when issue.id is issueId*1
		@

	getHtml: ->
		html = '<div class="left">'
		html += '<div class="list" id="' + list.id + '">' + list.getHtml() + '</div>' for key, list of @lists when list.type is 'sprint'
		html += '</div><div class="right">'
		html += '<div class="list" id="' + list.id + '">' + list.getHtml() + '</div>' for key, list of @lists when list.type is 'backlog'
		html += '</div><div style="clear: both;"></div>'
