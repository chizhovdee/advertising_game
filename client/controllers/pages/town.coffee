Page = require("../page")
modals = require('../modals')
request = require('../../lib/request')
balance = require('../../lib/balance')
ctx = require('../../context')
VisualTimer = require("../../lib").VisualTimer
MaterialType = require('../../game_data').MaterialType

class TownPage extends Page
  className: "town page"

  show: ->
    @playerState = ctx.get('playerState')

    @timers = {}

    @materialTypes = MaterialType.all()

    super

    @.defineData()

    @.render()

  hide: ->
    for id, timer of @timers
      timer.stop()

    super

  render: ->
    @html(@.renderTemplate("town/index"))

    @.setupTimers()

  setupTimers: ->
    record = @.firstDeliveredMaterial()

    if record?
      @timers.dailyLimit ?= new VisualTimer(null, => @.renderList())
      @timers.dailyLimit.setElement($(".trading .timer .value"))
      @timers.dailyLimit.start(record.actualTimeLeftToLimit())

  bindEventListeners: ->
    super

    @el.on('click', '.trading .material', @.onTradingMaterialClick)

  unbindEventListeners: ->
    super

    @el.off('click', '.trading .material', @.onTradingMaterialClick)

  defineData: ->



  onTradingMaterialClick: (e)=>
    materialEl = $(e.currentTarget)

    @.displayPopup(materialEl
      @.renderTemplate('town/material_popup',
        materialType: MaterialType.find(materialEl.data('material'))
        townMaterial: @playerState.findTownMaterialRecord(materialEl.data('material'))
      )
      position: 'top center'
      autoHideDelay: _(5).seconds()
      autoHide: true
    )

  firstDeliveredMaterial: ->
    for materialKey, record of @playerState.townMaterialRecords()
      return record if record.isDeliveredToday()

  isMaterialDeliveredToday: ->
    return true if @.firstDeliveredMaterial()?

    false


module.exports = TownPage
