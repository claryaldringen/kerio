
class Kerio.Request

	constructor: ->
		@tasks = []

	addTask: (task) ->
		@tasks.push task
		@

	send: ->
		task = @tasks[@tasks.length-1]
		$.ajax(type: 'POST', url: task.url, data: task.params).done (data) -> task.callback.call task.callbackObject, data
		@