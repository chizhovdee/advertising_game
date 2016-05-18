Modal = require("../modal")
Route = require('../../game_data').Route
Transport = require('../../game_data').Transport
request = require('../../lib').request

class StartRouteModal extends Modal
  className: 'start_route modal'

  show: (routeKey)->
    super

    @route = Route.find(routeKey)

    @transports = Transport.findAllByAttribute('typeKey', @route.typeKey)

    @.render()

  render: ->
    @updateContent(
      @.renderTemplate('routes/start')
    )

  bindEventListeners: ->
    super

    request.bind('trucking_created', @.onTruckingCreated)

    @el.on('click', 'button.select:not(.disabled)', @.onSelectClick)

  unbindEventListeners: ->
    super

    request.unbind('trucking_created', @.onTruckingCreated)

    @el.off('click', 'button.select:not(.disabled)', @.onSelectClick)

  onSelectClick: (e)=>
    button = $(e.currentTarget)
    button.addClass('disabled')

    request.send('create_trucking'
      route_id: @route.id
      transport_id: button.data('transport-id')
    )

  onTruckingCreated: (response)=>
    console.log response


module.exports = StartRouteModal