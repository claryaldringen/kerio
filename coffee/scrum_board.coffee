
class Kerio.ScrumBoard extends Kerio.Component

	constructor: (id, di, parent) ->
		super id, di, parent
		@statuses = [{id: 1, name: 'New'}, {id: 2, name: 'In Progress'}, {id: 3, name: 'Done'}]
		@userStories = {}

	load: ->
		@di.getRequest().addTask(@di.createTask('tests/requests/stories.json', {}, @loadResponse, @)).send()
		@

	loadResponse: (response) ->
		for story in response
			storyId = @id + '_' + story.id
			@userStories[storyId] = new Kerio.UserStory storyId, @di, @
			@userStories[storyId].setName(story.name).setDescription story.description
			for ticket in story.tickets
				kTicket = new Kerio.Ticket storyId + '_' + ticket.id, @di, @
				kTicket.setStatusId(ticket.status_id).setName ticket.name
				@userStories[storyId].addTicket kTicket
		@render()

	getHtml: ->
		html = '<table><tr><th>User Stories</th>'
		html += '<th>' + status.name + '</th>' for status in @statuses
		html += '</tr>'
		for iserStoryId, userStory of @userStories
			html += '<tr>'
			html += '<td>'  + userStory.getHtml() + '</td>'
			for status in @statuses
				html += '<td>'
				html += '<div id="' + ticket.id + '">' + ticket.getHtml() + '</div>' for ticketId, ticket of userStory.getTicketsByStatusId status.id
				html += '</td>'
			html += '</tr>'
		html += '</table>'