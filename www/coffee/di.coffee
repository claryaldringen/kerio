
class Kerio.Di

	constructor: ->
		@services = []
		@users = []
		@userId = null

	createTask: (url, params, callback, callbackObject) -> new Kerio.Task url, params, callback, callbackObject

	getRequest: ->
		@services['request'] = new Kerio.Request() if not @services['request']?
		@services['request']

	getListFactory: (id) ->
		@services['listFactory'] = {}
		@services['listFactory'][id] = new Kerio.ListFactory id, @, null

	getScrumBoard: (id) ->
		@services['scrumBoard'] = {}
		@services['scrumBoard'][id] = new Kerio.ScrumBoard id, @, null

	setUsers: (@users) -> @

	getUsers: -> @users

	load: -> @getRequest().addTask(@createTask('/ajax/load-general', {}, @loadResponse, @)).send()

	loadResponse: (response) ->
		@userId = response.userId
		@productd = response.productId
		@getListFactory('lists').load() if document.getElementById 'lists'
		@getScrumBoard('scrum_board').load() if document.getElementById 'scrum_board'

	createListItem: (id, parent) -> new Kerio.ListItem(id, @, parent)

	createList: (id, parent) -> new Kerio.SortableList(id, @, parent)