
class Kerio.Ticket extends Kerio.Component

	setName: (@name) -> @

	setStatusId: (@statusId) -> @

	getHtml: -> '<div>' + @name + '</div>'