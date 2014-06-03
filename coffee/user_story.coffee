
class Kerio.UserStory extends Kerio.Component

	constructor: (id, di, parent) ->
		super id, di, parent
		@tickets = {}

	setName: (@name) -> @

	setDescription: (@description) -> @

	getTicketsByStatusId: (statusId) -> ticket for ticketId, ticket of @tickets when ticket.statusId is statusId

	addTicket: (ticket) ->
		@tickets[ticket.id] = ticket
		@

	getHtml: -> '<div><h2>' + @name + '</h2>' + @description + '</div>'