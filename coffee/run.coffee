
$(document).ready ->
	di = new Kerio.Di()
	di.getListFactory('lists').load()