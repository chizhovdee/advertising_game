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

    if @carrying <= 0 || @acceptance <= 0 || @currentCount <= 0
      @sliderEl.setAttribute('disabled', true)
      @el.find('.section.ship .current_cargo').attr('disabled', true)

  bindEventListeners: ->
    super

    @el.on('click', '.section .add', @.onAddClick)
    @el.on('click', '.section .delete', @.onDeleteClick)
    @el.on('change', '.section.ship .current_cargo', @.onCurrentCargoChange)

  unbindEventListeners: ->
    super

    @el.off('click', '.section .add', @.onAddClick)
    @el.off('click', '.section .delete', @.onDeleteClick)
    @el.off('change', '.section.ship .current_cargo', @.onCurrentCargoChange)

  defineData: ->
    @destination = null
    @transportList = []
    @carrying = 0
    @acceptance = 0
    @currentCargo = 0

    switch @resource.type
      when 'factories'
        @sendingPlace = @playerState.findFactoryRecord(@resource.id)
        @currentCount = @playerState.getMaterialFor(@resource, @materialKey)

  applyDestination: (resource)->
    @destination = @playerState.findRecordByResource(resource)

    @.calculate()

    @.render()

  applyTransport: (transportId)->
    @transportList.push @playerState.findTransportRecord(transportId)

    @.calculate()

    @.render()

  calculate: ->
    if @destination
      current = @playerState.getMaterialFor(@playerState.getResourceFor(@destination), @materialKey)
      max = @destination.type().materialLimitBy(@materialKey, @destination.level)
      @acceptance = max - current
    else
      @acceptance = 0

    if @transportList.length > 0
      @carrying = _.sumBy(@transportList, (t)-> t.model().carrying)
    else
      @carrying = 0

    @maxCargo = _.min([@carrying, @acceptance, @currentCount])

    @currentCargo = 0

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
          transportList: @transportList
        )

  onDeleteClick: (e)=>
    el = $(e.currentTarget)

    if el.data('type') == 'destination'
      @destination = null

    else
      @transportList = _.reject(@transportList, (t)=> t.id == el.data('transport-id'))

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


module.exports = NewTruckingModal