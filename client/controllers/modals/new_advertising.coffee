Modal = require("../modal")
request = require("../../lib/request")
AdvertisingType = require('../../game_data').AdvertisingType

class NewAdvertisingModal extends Modal
  className: 'new_advertising modal'
  elements:
    '.time_generation .value': 'timeGenerationEl'
    '.price .value': 'priceEl'

  show: ->
    super

    @advertisingTypes = AdvertisingType.all()

    @advertisingData = {
      type: @advertisingTypes[0].key
      status: @settings.advertisingType.status[0]
      period: @settings.advertisingType.periods[0]
    }

    @advertisingType = _.find(@advertisingTypes, (type)=> @advertisingData.type == type.key)

    @.render()

  render: ->
    @updateContent(
      @.renderTemplate('advertising/new')
    )

  bindEventListeners: ->
    super

    request.bind('advertising_created', @.onCreated)

    @el.on('click', '.advertising_type:not(.selected)', @.onAdvertisingTypeClick)
    @el.on('click', '.period .radio_input:not(.selected)', @.onPeriodClick)
    @el.on('click', '.status .status_item:not(.selected)', @.onStatusClick)
    @el.on('click', '.controls .create:not(.disabled)', @.onCreateClick)
    @el.on('click', '.controls .start_create:not(.disabled)', @.onStartCreateClick)

  unbindEventListeners: ->
    super

    request.unbind('advertising_created', @.onCreated)

    @el.off('click', '.advertising_type:not(.selected)', @.onAdvertisingTypeClick)
    @el.off('click', '.period .radio_input:not(.selected)', @.onPeriodClick)
    @el.off('click', '.status .status_item:not(.selected)', @.onStatusClick)
    @el.off('click', '.controls .create:not(.disabled)', @.onCreateClick)
    @el.off('click', '.controls .start_create:not(.disabled)', @.onStartCreateClick)

  onAdvertisingTypeClick: (e)=>
    typeEl = $(e.currentTarget)

    @el.find('.advertising_type').removeClass('selected')

    typeEl.addClass('selected')

    @advertisingData.type = typeEl.data('type')
    @advertisingType = _.find(@advertisingTypes, (type)=> @advertisingData.type == type.key)

    @.updateView()

  onPeriodClick: (e)=>
    controlEl = $(e.currentTarget)

    @el.find('.period .radio_input').removeClass('selected')

    controlEl.addClass('selected')

    @advertisingData.period = controlEl.data('amount')

    @.updateView()

  onStatusClick: (e)=>
    statusEl = $(e.currentTarget)

    if statusEl.hasClass('locked')
      @.displayPopup(statusEl,
        @.renderTemplate("advertising/locked_status")
        position: 'top center'
        autoHide: true
      )
    else
      @el.find('.status .status_item').removeClass('selected')

      statusEl.addClass('selected')

      @advertisingData.status = statusEl.data('status')

      @.updateView()

  priceRequirements: ->
    price = Math.floor(
      @advertisingType.basicPrice *
      (1 - @settings.advertisingType.discountPerDay * (@advertisingData.period - 1))
    ) * @advertisingData.period * @settings.advertisingType.statusFactor[@advertisingData.status]

    {basic_money: [price, @player.basic_money >= price]}

  updateView: ->
    @timeGenerationEl.html(@.displayTime(@advertisingType.timeGeneration))
    @priceEl.html(@.renderTemplate('requirements', requirements: @.priceRequirements()))

  onCreateClick: (e)=>
    button = $(e.currentTarget)

    @.displayConfirm(button,
      position: 'right bottom'
      button:
        className: 'start_create'
        text: I18n.t('advertising.buttons.create_advertising')
    )

  onStartCreateClick: (e)=>
    button = $(e.currentTarget)
    return if button.data('type') == 'cancel'

    button.addClass('disabled')
    @el.find('.create').addClass('disabled')

    request.send('create_advertising', data: @advertisingData)

  onCreated: (response)=>
    if response.is_error
      @.render()

      @.displayResult(
        @el.find('.create')
        response
        position: "right bottom"
      )

    else
      @.close()


module.exports = NewAdvertisingModal