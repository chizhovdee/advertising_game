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

    @el.on('click', '.section .add', @.onAddClick)
    @el.on('click', '.section .delete', @.onDeleteClick)

  unbindEventListeners: ->
    super

    @el.off('click', '.section .add', @.onAddClick)
    @el.off('click', '.section .delete', @.onDeleteClick)

  defineData: ->
    @destination = null

    switch @resource.type
      when 'factories'
        @sendingPlace = @playerState.findFactoryRecord(@resource.id)

        @currentCount = @playerState.getMaterialFor(@resource, @materialKey)
        @maxCount = @sendingPlace.type().materialLimitBy(@materialKey, @sendingPlace.level)


  applyDestination: (resource)->
    @destination = @playerState.findRecordByResource(resource)

    @.render()

  onAddClick: (e)=>
    el = $(e.currentTarget)

    switch el.data('type')
      when 'destination'
        DestinationSelectionModal.show(@,
          materialKey: @materialKey
          resource: @resource
          sendingPlace: @sendingPlace
        )

  onDeleteClick: (e)=>
    el = $(e.currentTarget)

    switch el.data('type')
      when 'destination'
        @destination = null

    @.render()


module.exports = NewTruckingModal