Modal = require("../modal")
Advertising = require('../../game_data').Advertising

class AdvertisingPurchaseModal extends Modal
  className: 'advertising_purchase modal'

  show: (@context, type)->
    super

    @ad = Advertising.find(type)

    @.render()

  render: ->
    @updateContent(
      @.renderTemplate('advertising/purchase')
    )

  bindEventListeners: ->
    super


  unbindEventListeners: ->
    super

module.exports = AdvertisingPurchaseModal