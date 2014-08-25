
class Kerio.Event

	constructor: ->
		@callbacks = []

	subscribe: (callback, object) ->
		@callbacks.push func: callback, object: object
		@

	fire: ->
		callback.func.call callback.object for callback in @callbacks
		@
