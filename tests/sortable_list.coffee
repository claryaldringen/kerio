
describe 'Kerio.SortableList', ->

	object = null

	beforeEach -> object = new Kerio.SortableList 'bcklog'

	describe '#load', ->

		it 'should load list of issues', ->


	describe '#save', ->

		it 'should save position of issue in list', ->

	describe '#render', ->

		it 'should insert html code of component into DOM', ->

	describe '#getHmtl', ->

		it 'should return html code of component', ->

	describe '#bindEvents', ->

		it 'should make list sortable', ->



