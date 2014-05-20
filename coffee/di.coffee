
class Kerio.Di

	constructor: -> @services = []

	createTask: (url, params, callback, callbackObject) -> new Kerio.Task url, params, callback, callbackObject

	getRequest: ->
		@services['request'] = new Kerio.Request() if not @services['request']?
		@services['request']

	getListFactory: (id) ->
		@services['listFactory'] = {}
		@services['listFactory'][id] = new Kerio.ListFactory id, @, null
