
describe 'Kerio.SortableList', ->

	object = null
	di = new Kerio.Di()

	beforeEach -> object = new Kerio.SortableList 'bcklog', di

	describe '#setName', ->

		it 'should set name of list', ->
			expect(object.setName 'Backlog').toBe object
			expect(object.name).toBe 'Backlog'

	describe '#render', ->

		it 'should insert html code of component into DOM', ->
			document.write '<div id="bcklog"></div>'
			spyOn(object, 'getHtml').andReturn 'Sortable List Html'
			spyOn(object, 'bindEvents').andReturn object
			expect(object.render()).toBe object
			expect(object.bindEvents).toHaveBeenCalled()
			expect($('#bcklog').html()).toBe 'Sortable List Html'
