Page = require("../page")
modals = require('../modals')
request = require('../../lib/request')
balance = require('../../lib/balance')
MaterialType = require('../../game_data').MaterialType

class TownPage extends Page
  className: "town page"

  show: ->
    super

    @.defineData()

    @.render()

  render: ->
    @html(@.renderTemplate("town/index"))

  bindEventListeners: ->
    super

    @el.on('click', '.trading .material', @.onTradingMaterialClick)

  unbindEventListeners: ->
    super

    @el.off('click', '.trading .material', @.onTradingMaterialClick)

  defineData: ->
    @materialTypes = MaterialType.all()


  onTradingMaterialClick: (e)=>
    materialEl = $(e.currentTarget)

    @.displayPopup(materialEl
      @.renderTemplate('town/material_popup',
        materialType: MaterialType.find(materialEl.data('material'))
      )
      position: 'top center'
      autoHideDelay: _(5).seconds()
      autoHide: true
    )


module.exports = TownPage
