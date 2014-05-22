
class Kerio.ListFactory extends Kerio.Component

	constructor: (id, di, parent) ->
		super id, di
		@issues = []
		@lists = {}

	getHtml: ->

	load: ->
		@di.getRequest().addTask(@di.createTask('tests/requests/issues.json', {}, @loadResponse, @)).send()
		@

	loadResponse: (response) ->
		response.issues.sort (prev, next) -> prev.priority - next.priority
		for issue in response.issues
			if not @lists[issue.list]?
				@lists[issue.list] = new Kerio.SortableList @id + '_' + issue.list.replace(' ', '_'), @di, @
				@lists[issue.list].setName(issue.list)
			@lists[issue.list].add issue
		@render()

	getHtml: ->
		html = '<div class="left">'
		html += list.getHtml() for key, list of @lists when key isnt 'backlog'
		html += '</div><div class="right">'
		html += list.getHtml() for key, list of @lists when key is 'backlog'
		html += '</div>'
