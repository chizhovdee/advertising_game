Modal = require("../modal")
request = require('../../lib').request
TransportSelectionModal = require('./transport_selection')

Route = require('../../game_data').Route
Transport = require('../../game_data').Transport

class StartRouteModal extends Modal
  className: 'start_route modal'

  show: (routeId, @stateRouteId)->
    super

    console.log routeId, @stateRouteId

    @.defineData(routeId)

    @.render()

  render: ->
    @updateContent(
      @.renderTemplate('routes/start')
    )

  bindEventListeners: ->
    super

    request.bind('trucking_created', @.onTruckingCreated)

    @el.on('click', '.transport_list .add', @.onAddTransportClick)

  unbindEventListeners: ->
    super

    request.unbind('trucking_created', @.onTruckingCreated)

    @el.off('click', '.transport_list .add', @.onAddTransportClick)

  defineData: (routeId)->
    console.log @route = Route.find(routeId)

  # events
  onTruckingCreated: (response)=>
    console.log response

  onAddTransportClick: =>
    console.log 'onAddTransportClick'
    TransportSelectionModal.show()


module.exports = StartRouteModal