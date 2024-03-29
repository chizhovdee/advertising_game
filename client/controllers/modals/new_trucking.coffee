Modal = require("../modal")
request = require('../../lib').request
geometry = require('../../lib').geometry
TransportSelectionModal = require('./transport_selection')
DestinationSelectionModal = require('./destination_selection')
ctx = require('../../context')
gameData = require('../../game_data')
TransportModel = gameData.TransportModel
FactoryType = gameData.FactoryType
Town = require('../../models').Town

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

    @.createSlider()

  createSlider: ->
    @sliderEl = document.getElementById('slider')

    noUiSlider.create(@sliderEl,
      start: 0
      connect: 'lower'
      step: 1
      range: {
        'min': 0
        'max': @maxCargo || 1
      }
    )

    @sliderEl.noUiSlider.on('update', @.onSliderUpdate)

    @.checkEnabledSlider()

  checkEnabledSlider: ->
    if @carrying <= 0 || @acceptance <= 0 || @currentCount <= 0
      @sliderEl.setAttribute('disabled', true)
      @el.find('.section.ship .current_cargo').attr('disabled', true)
    else
      @sliderEl.removeAttribute('disabled')
      @el.find('.section.ship .current_cargo').attr('disabled', false)

  bindEventListeners: ->
    super

    request.bind('trucking_created', @.onTruckingCreated)

    @el.on('click', '.section:not(.disabled) .add', @.onAddClick)
    @el.on('click', '.section:not(.disabled) .delete', @.onDeleteClick)
    @el.on('change', '.section.ship:not(.disabled) .current_cargo', @.onCurrentCargoChange)
    @el.on('click', 'button.send:not(.disabled)', @.onSendClick)
    @el.on('click', 'button.start_sending:not(.disabled)', @.onStartSendingClick)

  unbindEventListeners: ->
    super

    request.unbind('trucking_created', @.onTruckingCreated)

    @el.off('click', '.section:not(.disabled) .add', @.onAddClick)
    @el.off('click', '.section:not(.disabled) .delete', @.onDeleteClick)
    @el.off('change', '.section.ship:not(.disabled) .current_cargo', @.onCurrentCargoChange)
    @el.off('click', 'button.send:not(.disabled)', @.onSendClick)
    @el.off('click', 'button.start_sending:not(.disabled)', @.onStartSendingClick)

  defineData: ->
    @destination = null
    @transport = null
    @carrying = 0
    @acceptance = 0
    @currentCargo = 0
    @travelTime = 0

    switch @resource.type
      when 'factories'
        @sendingPlace = @playerState.findFactoryRecord(@resource.id)
        @currentCount = @playerState.getMaterialFor(@resource, @materialKey)

  applyDestination: (resource)->
    @destination = @playerState.findRecordByResource(resource)

    @.calculate()

    @.render()

  applyTransport: (transportId)->
    @transport = @playerState.findTransportRecord(transportId)

    @.calculate()

    @.render()

  calculate: ->
    if @destination
      if @destination.id == 'town'
        materialData = @destination.getMaterialDataForTrucking(@materialKey)
        current = materialData.currentCount
        max = materialData.maxCount

      else
        current = @playerState.getMaterialFor(@playerState.getResourceFor(@destination), @materialKey)
        max = @destination.type().materialLimitBy(@materialKey, @destination.level)

      @acceptance = max - current
    else
      @acceptance = 0

    if @transport?
      @carrying = @transport.model().carrying
    else
      @carrying = 0

    @maxCargo = _.min([@carrying, @acceptance, @currentCount])

    @currentCargo = 0

    if @destination? && @transport?
      distance = geometry.pDistance(@sendingPlace.type().position, @destination.type().position)

      @travelTime = _(Math.ceil(distance / @transport.model().travelSpeed * 60)).minutes()
    else
      @travelTime = 0

  onAddClick: (e)=>
    el = $(e.currentTarget)

    switch el.data('type')
      when 'destination'
        DestinationSelectionModal.show(@,
          materialKey: @materialKey
          resource: @resource
          sendingPlace: @sendingPlace
        )
      else
        TransportSelectionModal.show(@,
          materialKey: @materialKey
          resource: @resource
        )

  onDeleteClick: (e)=>
    el = $(e.currentTarget)

    if el.data('type') == 'destination'
      @destination = null

    else
      @transport = null

    @.calculate()

    @.render()

  onSliderUpdate: (value)=>
    @currentCargo = _.toInteger(value[0])

    @el.find('.section.ship .current_cargo').val(@currentCargo)

    buttonEl = @el.find('button.send')

    if @currentCargo <= 0
      buttonEl.addClass('disabled') unless buttonEl.hasClass('disabled')
    else
      buttonEl.removeClass('disabled')

  onCurrentCargoChange: (e)=>
    @sliderEl.noUiSlider.set($(e.currentTarget).val())

  onSendClick: (e)=>
    e.stopPropagation()

    @.displayConfirm($(e.currentTarget),
      button:
        className: 'start_sending'
      position: 'right bottom'
    )

  onStartSendingClick: (e)=>
    $(e.currentTarget).addClass('disabled')

    @.controlsEnable(false)

    request.send('create_trucking',
      destination: @playerState.getResourceFor(@destination)
      transport_id: @transport.id
      sending_place: @playerState.getResourceFor(@sendingPlace)
      material: @materialKey
      amount: @currentCargo
    )

  controlsEnable: (bool)->
    if bool
      @el.find('button.send').removeClass('disabled')
      @el.find('.section').removeClass('disabled')

      @.checkEnabledSlider()

    else
      @el.find('button.send').addClass('disabled')
      @el.find('.section').addClass('disabled')
      @sliderEl.setAttribute('disabled', true)
      @el.find('.section.ship .current_cargo').attr('disabled', true)

  onTruckingCreated: (response)=>
    if response.is_error
      @.render()

      @.displayResult(
        @el.find('button.send')
        response
        position: "right bottom"
      )

    else
      @.close()

module.exports = NewTruckingModal