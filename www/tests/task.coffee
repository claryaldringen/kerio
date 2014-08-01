
describe 'Kerio.Task', ->

	object = null
	handler = null

	beforeEach ->
		handler =
			handleResponse: ->
		object = new Kerio.Task 'url', {foo: 'bar'}, handler.handleResponse, handler

	describe '#constructor', ->

		it 'should create Kerio.Task object with specified params', ->
			expect(object instanceof Kerio.Task).toBeTruthy()
			expect(object.url).toBe 'url'
			expect(object.params).toEqual {foo: 'bar'}
			expect(object.callback).toBe handler.handleResponse
			expect(object.callbackObject).toBe handler