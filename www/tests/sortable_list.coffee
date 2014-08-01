
describe 'Kerio.SortableList', ->

	object = null
	di = new Kerio.Di()

	beforeEach -> object = new Kerio.SortableList 'bcklog', di

	describe '#setName', ->

		it 'should set name of list', ->
			expect(object.setName 'Backlog').toBe object
			expect(object.name).toBe 'Backlog'

	describe '#load', ->

		it 'should load list of issues', ->
			request =
				addTask: ->
				send: ->
			spyOn(request, 'addTask').andReturn request
			spyOn(request, 'send')
			spyOn(di, 'getRequest').andReturn request
			spyOn(di, 'createTask').andReturn url: 'url', params: {}, callback: object.loadResponse, callbackObject: object
			expect(object.load()).toBe object
			expect(request.addTask).toHaveBeenCalledWith url: 'url', params: {}, callback: object.loadResponse, callbackObject: object
			expect(request.send).toHaveBeenCalled()

	describe '#loadResponse', ->

		it 'should set list of the issues', ->
			me = render: ->
			spyOn(me, 'render')
			issues = [
				{name: 'Issue 1', description: 'Description of issue 1.', priority: 3}
				{name: 'Issue 2', description: 'Description of issue 2.', priority: 2}
				{name: 'Issue 3', description: 'Description of issue 3.', priority: 1}
				]
			sortedIssues = [
				{name: 'Issue 3', description: 'Description of issue 3.', priority: 1}
				{name: 'Issue 2', description: 'Description of issue 2.', priority: 2}
				{name: 'Issue 1', description: 'Description of issue 1.', priority: 3}
			]
			object.loadResponse {issues: issues}, me
			expect(me.issues).toEqual sortedIssues
			expect(me.render).toHaveBeenCalled()

	describe '#save', ->

		it 'should save position of issue in list', ->
			object.issues = [
				{id: 1, name: 'Issue 1', description: 'Description of issue 1.', priority: 1}
				{id: 2, name: 'Issue 2', description: 'Description of issue 2.', priority: 2}
				{id: 3, name: 'Issue 3', description: 'Description of issue 3.', priority: 3}
			]
			issues = [
				{id: 1, name: 'Issue 1', description: 'Description of issue 1.', priority: 2}
				{id: 2, name: 'Issue 2', description: 'Description of issue 2.', priority: 3}
				{id: 3, name: 'Issue 3', description: 'Description of issue 3.', priority: 1}
			]
			sort = ['id_2', 'id_3', 'id_1']
			request =
				addTask: ->
				send: ->
			spyOn(request, 'addTask').andReturn request
			spyOn(request, 'send')
			spyOn(di, 'getRequest').andReturn request
			spyOn(di, 'createTask').andReturn 'url', issues, object, object.saveResponse
			expect(object.save(sort)).toBe object

	describe '#render', ->

		it 'should insert html code of component into DOM', ->
			document.write '<div id="bcklog"></div>'
			spyOn(object, 'getHtml').andReturn 'Sortable List Html'
			spyOn(object, 'bindEvents').andReturn object
			expect(object.render()).toBe object
			expect(object.bindEvents).toHaveBeenCalled()
			expect($('#bcklog').html()).toBe 'Sortable List Html'

	describe '#getHmtl', ->

		it 'should return html code of component', ->
			object.name = 'Backlog'
			object.issues = [
				{id: 3, name: 'Issue 3', description: 'Description of issue 3.', priority: 1}
				{id: 1, name: 'Issue 1', description: 'Description of issue 1.', priority: 2}
				{id: 2, name: 'Issue 2', description: 'Description of issue 2.', priority: 3}
			]
			html = '<div class="title">Backlog</div><ul><li class="issue">Issue 3</li><li class="issue">Issue 1</li><li class="issue">Issue 2</li></ul>'
			expect(object.getHtml()).toBe html

	describe '#bindEvents', ->

		it 'should make list sortable', ->



