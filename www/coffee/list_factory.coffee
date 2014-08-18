
class Kerio.ListFactory extends Kerio.Component

	BACKLOG_ID = 1

	constructor: (id, di, parent) ->
		super id, di
		@issues = []
		@lists = {}
		@changed = no

	getHtml: ->

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
			list.issues = [] for listId, list of @lists
			for issue in @issues
				if not @lists[issue.list_id]?
					@lists[issue.list_id] = new Kerio.SortableList(@id + '_' + issue.list_id, @di, @)
					@lists[issue.list_id].setName(issue.list_name).setListId(issue.list_id).setType(issue.list_type)
				@lists[issue.list_id].setIssue issue if issue.id?
			@changed = no
			@render()
		@

	setListToIssue: (list, issueId) ->
		for issue,i in @issues when issue.id is issueId*1 and issue.list_id isnt list.getListId()
			@issues[i].list_name = list.getName()
			@issues[i].list_id = list.getListId()
			@changed = yes
		@

	setPriorityToIssue: (priority, issueId) ->
		@issues[i].priority = priority for issue,i in @issues when issue.id is issueId*1
		@

	getHtml: ->
		html = '<div class="left">'
		html += '<div class="list" id="' + list.id + '">' + list.getHtml() + '</div>' for key, list of @lists when list.type is 'left'
		html += '</div><div class="right">'
		html += '<div class="list" id="' + list.id + '">' + list.getHtml() + '</div>' for key, list of @lists when list.type is 'right'
		html += '</div><div style="clear: both;"></div>'
