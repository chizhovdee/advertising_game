Modal = require("../modal")
request = require("../../lib/request")
AdvertisingType = require('../../game_data').AdvertisingType
ctx = require('../../context')

class ProlongAdvertisingModal extends Modal
  className: 'prolong_advertising modal'

  show: (advertisingId)->
    super

    @playerState = ctx.get('playerState')

    @advertising = @playerState.findAdvertisingRecord(advertisingId)

    @selectedPeriod = 1

    @.render()

  render: ->
    @updateContent(
      @.renderTemplate('advertising/prolong')
    )

  bindEventListeners: ->
    super

    request.bind('advertising_prolonged', @.onAdvertisingProlonged)

    @el.on('click', '.period .radio_input:not(.selected)', @.onPeriodClick)
    @el.on('click', '.prolong:not(.disabled)', @.onProlongClick)

  unbindEventListeners: ->
    super

    request.unbind('advertising_prolonged', @.onAdvertisingProlonged)

    @el.off('click', '.period .radio_input:not(.selected)', @.onPeriodClick)
    @el.off('click', '.prolong:not(.disabled)', @.onProlongClick)

  priceRequirements: ->
    price = Math.floor(
      @advertising.type.basicPrice *
        (1 - @settings.advertisingType.discountPerDay * (@selectedPeriod - 1))
    ) * @selectedPeriod * @settings.advertisingType.statusFactor[@advertising.status]

    {basic_money: [price, @player.basic_money >= price]}

  onPeriodClick: (e)=>
    controlEl = $(e.currentTarget)

    @el.find('.period .radio_input').removeClass('selected')

    controlEl.addClass('selected')

    @selectedPeriod = controlEl.data('amount')

    @el.find('.price .value').html(
      @.renderTemplate('requirements', requirements: @.priceRequirements())
    )

  onProlongClick: (e)=>
    $(e.currentTarget).addClass('disabled')

    request.send('prolong_advertising',
      advertising_id: @advertising.id
      period: @selectedPeriod
    )

  onAdvertisingProlonged: (response)=>
    if response.is_error
      @.render()

      @.displayResult(
        @el.find('.prolong')
        response
        position: "right bottom"
        errorArgs: {
          count: @settings.advertisingType.maxDuration if response.error_code == 'advertising_reached_max_duration'
        }
      )

    else
      @.close()

module.exports = ProlongAdvertisingModal