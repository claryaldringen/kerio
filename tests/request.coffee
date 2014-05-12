
describe 'Kerio.Request', ->

	object = null

	beforeEach -> object = new Kerio.Request()

	describe '#addTask', ->

		it 'should add ajax request task into list of tasks', ->
			expect(object.addTask 'some task').toBe object
			expect(object.tasks).toEqual ['some task']

	describe '#send', ->

		it 'should send ajax request task', ->
			expect(object.send()).toBe object
