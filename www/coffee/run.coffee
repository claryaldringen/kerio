
$(document).ready ->
	di = new Kerio.Di()
	di.getListFactory('lists').load() if document.getElementById 'lists'
	di.getScrumBoard('scrum_board').load() if document.getElementById 'scrum_board'