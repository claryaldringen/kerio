
describe 'Kerio.Request', ->

	object = null

	beforeEach -> object = new Kerio.Request()

	describe '#addTask', ->

		it 'should add ajax request task into list of tasks', ->
			expect(object.addTask 'some task').toBe object
			expect(object.tasks).toEqual ['some task']

	describe '#send', ->

		it 'should send ajax request task', ->
			spyOn(JSON, 'parse').andReturn  response_code: 1, message: 'Hello World.'
			me = someHandler: ->
			spyOn(me, 'someHandler')
			object.tasks[0] =
				url: './base/tests/test1.json'
				params: foo: 'bar'
				callback: me.someHandler
				callbackObject: me
			expect(object.send()).toBe object
			waitsFor(
				-> me.someHandler.callCount > 0
			'The Ajax call timed out.'
			5000)
			runs -> expect(me.someHandler).toHaveBeenCalledWith response_code: 1, message: 'Hello World.'
