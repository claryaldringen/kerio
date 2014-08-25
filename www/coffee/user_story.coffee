
class Kerio.UserStory extends Kerio.Component

	constructor: (id, di, parent) ->
		super id, di, parent
		@tickets = {}

	setName: (@name) -> @

	setDescription: (@description) -> @

	getTicketsByStatusId: (statusId) -> ticket for ticketId, ticket of @tickets when ticket.statusId is statusId

	getTicketById: (ticketId) -> @tickets[ticketId]

	addTicket: (ticket) ->
		ticket.getEvent('change').subscribe @ticketChange, @
		@tickets[ticket.id] = ticket
		@

	ticketChange: -> @getEvent('change').fire()

	getHtml: -> '<div><h2>' + @name + '</h2><p>' + (if @description? then @description else '') + '</p></div>'