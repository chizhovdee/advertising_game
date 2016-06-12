Modal = require("../modal")
request = require('../../lib').request
TransportSelectionModal = require('./transport_selection')
ctx = require('../../context')
Route = require('../../game_data').Route
Transport = require('../../game_data').Transport

class StartRouteModal extends Modal
  className: 'start_route modal'

  show: (@routeId, @stateRouteId)->
    @playerState = ctx.get('playerState')

    super

    @.defineData()

    @.render()

  render: ->
    @updateContent(
      @.renderTemplate('routes/start')
    )

  bindEventListeners: ->
    super

    request.bind('trucking_created', @.onTruckingCreated)

    @el.on('click', '.transport_list .add', @.onAddTransportClick)
    @el.on('click', '.transport .delete', @.onTransportDeleteClick)
    @el.on('click', '.send', @.onSendClick)

  unbindEventListeners: ->
    super

    request.unbind('trucking_created', @.onTruckingCreated)

    @el.off('click', '.transport_list .add', @.onAddTransportClick)
    @el.off('click', '.transport .delete', @.onTransportDeleteClick)
    @el.off('click', '.send', @.onSendClick)

  defineData: ->
    console.log @route = Route.find(@routeId)

    @transportIds = []
    @totalCarrying = 0
    @time = 0
    @fuel = 0

  # events
  onTruckingCreated: (response)=>
    console.log response

  onAddTransportClick: =>
    TransportSelectionModal.show(@, @routeId, @transportIds)

  addTransport: (transportId)->
    @transportIds.push(transportId)

    @.calculateData()

    @.render()

  deleteTransport: (transportId)->
    @transportIds = _.reject(@transportIds, (id)-> id == transportId)

    @.calculateData()

    @.render()

  calculateData: ->
    @totalCarrying = 0
    @time = 0
    @fuel = 0

    for tId in @transportIds
      type = Transport.find(@playerState.transport[tId].typeId)
      @totalCarrying += type.carrying
      @time = Math.floor((_(1).hours() / type.travelSpeed) * @route.distance)
      @fuel += (type.consumption / 100) * @route.distance

  fuelRequirements: ->
    {fuel: [@fuel , @player.fuel >= @fuel]}

  onTransportDeleteClick: (e)=>
    @.deleteTransport($(e.currentTarget).data('transport-id'))

  onSendClick: =>
    console.log 'send'

module.exports = StartRouteModal