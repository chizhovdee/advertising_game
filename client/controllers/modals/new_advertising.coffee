Modal = require("../modal")
request = require("../../lib/request")
AdvertisingType = require('../../game_data').AdvertisingType

class NewAdvertisingModal extends Modal
  className: 'new_advertising modal content_modal'
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

  unbindEventListeners: ->
    super

    request.unbind('advertising_created', @.onCreated)

    @el.off('click', '.advertising_type:not(.selected)', @.onAdvertisingTypeClick)
    @el.off('click', '.period .radio_input:not(.selected)', @.onPeriodClick)
    @el.off('click', '.status .status_item:not(.selected)', @.onStatusClick)
    @el.off('click', '.controls .create:not(.disabled)', @.onCreateClick)

  onAdvertisingTypeClick: (e)=>
    typeEl = $(e.currentTarget)

    @el.find('.advertising_type').removeClass('selected')

    typeEl.addClass('selected')
    console.log typeEl.data('type')

    @advertisingData.type = typeEl.data('type')
    @advertisingType = _.find(@advertisingTypes, (type)=> @advertisingData.type == type.key)

    @.updateView()

  onPeriodClick: (e)=>
    controlEl = $(e.currentTarget)

    @el.find('.period .radio_input').removeClass('selected')

    controlEl.addClass('selected')
    console.log controlEl.data('amount')

    @advertisingData.period = controlEl.data('amount')

    @.updateView()

  onStatusClick: (e)=>
    statusEl = $(e.currentTarget)

    @el.find('.status .status_item').removeClass('selected')

    statusEl.addClass('selected')
    console.log statusEl.data('status')

    @advertisingData.status = statusEl.data('status')

    @.updateView()

  priceRequirements: ->
    price = Math.floor(
      @advertisingType.basicPrice * (1 - @settings.advertisingType.discountPerDay * (@advertisingData.period - 1))
    ) * @settings.advertisingType.statusFactor[@advertisingData.status]

    {basic_money: [price, @player.basic_money >= price]}

  updateView: ->
    @timeGenerationEl.html(@.displayTime(@advertisingType.timeGeneration))
    @priceEl.html(@.renderTemplate('requirements', requirements: @.priceRequirements()))

  onCreateClick: (e)=>
    $(e.currentTarget).addClass('disabled')

    request.send('create_advertising', data: @advertisingData)

  onCreated: (response)=>
    console.log 'onCreated', response

module.exports = NewAdvertisingModal