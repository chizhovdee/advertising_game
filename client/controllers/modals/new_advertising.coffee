Modal = require("../modal")
AdvertisingType = require('../../game_data').AdvertisingType

class NewAdvertisingModal extends Modal
  className: 'new_advertising modal content_modal'

  show: ->
    super

    @advertisingTypes = AdvertisingType.all()

    @.render()

  render: ->
    @updateContent(
      @.renderTemplate('advertising/new')
    )

  bindEventListeners: ->
    super

    @el.on('click', '.advertising_type:not(.selected)', @.onAdvertisingTypeClick)
    @el.on('click', '.period .radio_input', @.onPeriodClick)

  unbindEventListeners: ->
    super

    @el.off('click', '.advertising_type:not(.selected)', @.onAdvertisingTypeClick)
    @el.off('click', '.period .radio_input', @.onPeriodClick)

  onAdvertisingTypeClick: (e)=>
    typeEl = $(e.currentTarget)

    @el.find('.advertising_type').removeClass('selected')

    typeEl.addClass('selected')
    console.log typeEl.data('type')

  onPeriodClick: (e)=>
    controlEl = $(e.currentTarget)

    @el.find('.period .radio_input').removeClass('selected')

    controlEl.addClass('selected')
    console.log controlEl.data('amount')

module.exports = NewAdvertisingModal