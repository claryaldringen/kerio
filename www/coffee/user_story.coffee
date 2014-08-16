
class Kerio.UserStory extends Kerio.Component

	constructor: (id, di, parent) ->
		super id, di, parent
		@tickets = {}

	setName: (@name) -> @

	setDescription: (@description) -> @

	getTicketsByStatusId: (statusId) -> ticket for ticketId, ticket of @tickets when ticket.statusId is statusId

	getTicketById: (ticketId) -> @tickets[ticketId]

	addTicket: (ticket) ->
		@tickets[ticket.id] = ticket
		@

	getHtml: -> '<div><h2>' + @name + '</h2>' + (if @description? then @description else '') + '</div>'