InnerPage = require("../inner_page")
modals = require('../modals')
request = require("../../lib/request")
Advertising = require('../../game_data').Advertising

class AdvertisingPage extends InnerPage
  className: 'advertising inner_page'

  show: ->
    super

    @advertising = Advertising.all()

    @.render()

  render: ->
    @html(@.renderTemplate("advertising/index"))

  bindEventListeners: ->
    super

    @el.on('click', '.ad .buy', @.onBuyClick)

  unbindEventListeners: ->
    super

    @el.off('click', '.ad .buy', @.onBuyClick)

  onBuyClick: (e)=>
    modals.AdvertisingPurchaseModal.show(@, $(e.currentTarget).data('type'))

module.exports = AdvertisingPage