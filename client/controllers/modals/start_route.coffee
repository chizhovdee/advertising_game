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
    @el.on('click', '.send:not(.disabled)', @.onSendClick)
    @el.on('click', '.confirm_popup .run_route:not(.disabled)', @.onRunRouteClick)

  unbindEventListeners: ->
    super

    request.unbind('trucking_created', @.onTruckingCreated)

    @el.off('click', '.transport_list .add', @.onAddTransportClick)
    @el.off('click', '.transport .delete', @.onTransportDeleteClick)
    @el.off('click', '.send:not(.disabled)', @.onSendClick)
    @el.off('click', '.confirm_popup .run_route:not(.disabled)', @.onRunRouteClick)

  defineData: ->
    console.log @route = Route.find(@routeId)

    @transportIds = []
    @totalCarrying = 0
    @time = 0
    @fuel = 0

  # events
  onTruckingCreated: (response)=>
    console.log response

    @.close()

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
      @time = Math.ceil((_(1).hours() / type.travelSpeed) * @route.distance)
      @fuel += Math.ceil((type.consumption / 100) * @route.distance)

  fuelRequirements: ->
    {fuel: [@fuel , @player.fuel >= @fuel]}

  onTransportDeleteClick: (e)=>
    @.deleteTransport($(e.currentTarget).data('transport-id'))

  onSendClick: (e)=>
    @.displayConfirm($(e.currentTarget),
      button:
        className: 'run_route'
      position: 'right bottom'
    )

  onRunRouteClick: (e)=>
    # TODO проверки и валидации
    button = $(e.currentTarget)
    return if button.data('type') == 'cancel'

    $(e.currentTarget).addClass('disabled')
    @el.find('button.send').addClass('disabled')

    request.send('create_trucking',
      state_route_id: @stateRouteId
      transport_ids: @transportIds.join(',')
    )


module.exports = StartRouteModal