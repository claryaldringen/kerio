
describe 'Kerio.Di', ->

	object = null

	beforeEach -> object = new Kerio.Di()

	describe '#createTask', ->

		it 'should create, set and return instance of Kerio.Task', ->
			me = handle: ->
			expect(object.createTask 'url', {params: 'foo'}, me.handle, me ).toEqual new Kerio.Task 'url', {params: 'foo'}, me.handle, me

	describe '#getRequest', ->

		it 'should create and return instance of Kerio.Request', ->
			expect(object.getRequest() instanceof Kerio.Request).toBeTruthy()

		it 'should return once created instance of Kerio.Request', ->
			expect(object.getRequest()).toBe object.getRequest()
