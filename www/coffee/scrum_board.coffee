
class Kerio.ScrumBoard extends Kerio.Component

	constructor: (id, di, parent) ->
		super id, di, parent
		@statuses = [{id: 1, name: 'New'}, {id: 2, name: 'In Progress'}, {id: 3, name: 'Done'}]
		@userStories = {}

	getElPlaceId: (userStoryId, statusId) -> @id + '_' + userStoryId + '_' + statusId

	load: ->
		@di.getRequest().addTask(@di.createTask('/ajax/load-scrumboard', {id: $('#' + @id).attr('listid')}, @loadResponse, @)).send()
		@

	loadResponse: (response) ->
		@statuses = response.statuses
		@di.setUsers(response.users)
		for story in response.stories
			storyId = @id + '_' + story.id
			@userStories[storyId] = new Kerio.UserStory storyId, @di, @
			@userStories[storyId].getEvent('change').subscribe @onStoryChange, @
			@userStories[storyId].setName(story.name).setDescription story.description
			for ticket in story.tickets
				kTicket = new Kerio.Ticket storyId + '_' + ticket.id, @di, @
				kTicket.setStatusId(ticket.status_id).setName(ticket.name).setTicketId(ticket.id).setOwner(ticket.owner);
				@userStories[storyId].addTicket kTicket
		@render()

	save: (ticketId, statusId) ->
		@di.getRequest().addTask(@di.createTask('/ajax/save-scrumboard', {ticketId: ticketId, statusId: statusId}, @saveResponse, @)).send()
		@

	saveResponse: (response) ->

	onStoryChange: -> alert 'foo'

	dropTicket: (userStoryId, ticketId, statusId) ->
		ticket = @userStories[userStoryId].getTicketById ticketId
		ticket.setStatusId statusId*1
		@save(ticket.getTicketId(), statusId).render()

	bindEvents: ->
		super()
		$('.dropable').bind 'dragover', (event) => event.preventDefault()
		$('.dropable').bind 'drop', (event) =>
			event.preventDefault()
			data = JSON.parse event.dataTransfer.getData 'Text'
			@dropTicket  `$(this).attr('userStoryId')`, data.id, `$(this).attr('statusId')`

	getHtml: ->
		html = '<table class="scrum-board"><tr><th>User Stories</th>'
		html += '<th>' + status.name + '</th>' for status in @statuses
		html += '</tr>'
		for userStoryId, userStory of @userStories
			html += '<tr>'
			html += '<td>'  + userStory.getHtml() + '</td>'
			for status in @statuses
				html += '<td class="dropable" userStoryId="' + userStoryId + '" statusId="' + status.id + '">'
				html += '<div id="' + ticket.id + '" draggable="true" class="ticket-outer">' + ticket.getHtml() + '</div>' for ticketId, ticket of userStory.getTicketsByStatusId status.id
				html += '</td>'
			html += '</tr>'
		html += '</table>'