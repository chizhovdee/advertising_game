Modal = require("../modal")
request = require('../../lib').request
TransportSelectionModal = require('./transport_selection')
DestinationSelectionModal = require('./destination_selection')
ctx = require('../../context')
gameData = require('../../game_data')
TransportModel = gameData.TransportModel
FactoryType = gameData.FactoryType

class NewTruckingModal extends Modal
  className: 'new_trucking modal'

  show: (@resource, @materialKey)->
    @playerState = ctx.get('playerState')

    super

    @.defineData()

    @.render()

  render: ->
    @updateContent(
      @.renderTemplate('trucking/new')
    )

  bindEventListeners: ->
    super

    #request.bind('trucking_created', @.onTruckingCreated)

#    @el.on('click', '.transport_list .add', @.onAddTransportClick)
#    @el.on('click', '.transport .delete', @.onTransportDeleteClick)
#    @el.on('click', '.send:not(.disabled)', @.onSendClick)
    @el.on('click', '.section .add', @.onAddClick)

  unbindEventListeners: ->
    super

    #request.unbind('trucking_created', @.onTruckingCreated)

#    @el.off('click', '.transport_list .add', @.onAddTransportClick)
#    @el.off('click', '.transport .delete', @.onTransportDeleteClick)
#    @el.off('click', '.send:not(.disabled)', @.onSendClick)

    @el.off('click', '.section .add', @.onAddClick)

  defineData: ->
    @destination = null

    switch @resource.type
      when 'factories'
        factory = @playerState.findFactoryRecord(@resource.id)

        @senderPlace = FactoryType.find(factory.factoryTypeId)

        @currentCount = @playerState.getMaterialFor(@resource, @materialKey)
        @maxCount = @senderPlace.materialLimitBy(@materialKey, factory.level)


# events
#  onTruckingCreated: (response)=>
#    console.log response
#
#    @.close()
#
#  onAddTransportClick: =>
#    TransportSelectionModal.show(@, @routeId, @transportIds)
#
#  addTransport: (transportId)->
#    @transportIds.push(transportId)
#
#    @.calculateData()
#
#    @.render()
#
#  deleteTransport: (transportId)->
#    @transportIds = _.reject(@transportIds, (id)-> id == transportId)
#
#    @.calculateData()
#
#    @.render()
#
#  calculateData: ->
#    @totalCarrying = 0
#    @time = 0
#    @fuel = 0
#
#    for tId in @transportIds
#      type = Transport.find(@playerState.transport[tId].typeId)
#      @totalCarrying += type.carrying
#      @time = Math.ceil((_(1).hours() / type.travelSpeed) * @route.distance)
#      @fuel += Math.ceil((type.consumption / 100) * @route.distance)
#
#
#  onTransportDeleteClick: (e)=>
#    @.deleteTransport($(e.currentTarget).data('transport-id'))
#
#  onSendClick: (e)=>
#    @.displayConfirm($(e.currentTarget),
#      button:
#        className: 'run_route'
#      position: 'right bottom'
#    )
#
#  onRunRouteClick: (e)=>
#    # TODO проверки и валидации
#    button = $(e.currentTarget)
#    return if button.data('type') == 'cancel'
#
#    $(e.currentTarget).addClass('disabled')
#    @el.find('button.send').addClass('disabled')
#
#    request.send('create_trucking',
#      state_route_id: @stateRouteId
#      transport_ids: @transportIds.join(',')
#    )

  onAddClick: (e)=>
    el = $(e.currentTarget)

    switch el.data('type')
      when 'destination'
        DestinationSelectionModal.show(@,
          senderPlace: @senderPlace
          materialKey: @materialKey
          resource: @resource
        )

  # utils
  senderPlacePicture: ->
    switch @resource.type
      when 'factories'
        @.factoryPicture(@senderPlace)

module.exports = NewTruckingModal