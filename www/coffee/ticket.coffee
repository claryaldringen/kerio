
class Kerio.Ticket extends Kerio.Component

	constructor: (id, parent, di) ->
		super id, parent, di
		@owner =
			id: 0
			name: ''
			color: '#FFFFFF'

	getElSelectId: -> @id + '_select'

	setName: (@name) -> @

	setStatusId: (@statusId) -> @

	setTicketId: (@ticketId) -> @

	getTicketId: -> @ticketId

	setOwner: (userId) ->
		@owner = user for user in @di.getUsers() when user.id is userId
		@

	assign: (userId) ->
		changeStatus = if @owner.id is 0 then yes else no
		@di.getRequest().addTask(@di.createTask('/ajax/save-assign', {ticketId: @ticketId, userId: userId, changeStatus: changeStatus}, @saveResponse, @)).send()
		@setOwner(userId*1)
		if changeStatus then @getEvent('change').fire() else @render()

	saveResponse: ->

	dragStart: (event) -> event.dataTransfer.setData 'Text', JSON.stringify {id: @id, ticket_id: @ticketId, status_id: @statusId}

	bindEvents: ->
		jQuery.event.props.push 'dataTransfer'
		$('#' + @id).bind 'dragstart', (event) => @dragStart event
		$('#' + @getElSelectId()).bind 'change', => @assign $('#' + @getElSelectId()).val()

	getHtml: ->
		html = '<div style="background: ' + @owner.color + '" class="ticket">' + @name
		html += '<select id="' + @getElSelectId() + '"><option value="' + @owner.id + '">' + @owner.name + '</option>'
		html += '<option value="' + user.id + '">' + user.name + '</option>' for user in @di.getUsers() when user.id isnt @owner.id
		html += '</select>'
		html += '</div>'