
class Kerio.Request

	constructor: ->
		@tasks = []

	addTask: (task) ->
		@tasks.push task
		@

	send: ->
		task = @tasks[@tasks.length-1]
		$.ajax(type: 'POST', url: task.url, data: {data: JSON.stringify(task.params)}).done (data) -> task.callback.call task.callbackObject, JSON.parse(data)
		@