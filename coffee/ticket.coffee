
class Kerio.Ticket extends Kerio.Component

	setName: (@name) -> @

	setStatusId: (@statusId) -> @

	setTicketId: (@ticketId) -> @

	dragStart: (event) -> event.dataTransfer.setData 'Text', JSON.stringify {id: @id, ticket_id: @ticketId, status_id: @statusId}

	bindEvents: ->
		jQuery.event.props.push 'dataTransfer'
		$('#' + @id).bind 'dragstart', (event) => @dragStart event

	getHtml: -> '<div>' + @name + '</div>'