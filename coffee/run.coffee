
$(document).ready ->
	di = new Kerio.Di()
	di.getListFactory('lists').load()
	di.getScrumBoard('scrum_board').load()