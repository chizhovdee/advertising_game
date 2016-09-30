Page = require("../page")
modals = require('../modals')
request = require('../../lib/request')
balance = require('../../lib/balance')
ctx = require('../../context')
VisualTimer = require("../../lib").VisualTimer
MaterialType = require('../../game_data').MaterialType
TownLevel = require('../../game_data').TownLevel

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

    request.bind('town_bonus_collected', @.onBonusCollected)

    @el.on('click', '.trading .material', @.onTradingMaterialClick)
    @el.on('click', '.improvement .material', @.onImprovementMaterialClick)
    @el.on('click', '.bonus .collect:not(.disabled)', @.onBonusCollectClick)

  unbindEventListeners: ->
    super

    request.unbind('town_bonus_collected', @.onBonusCollected)

    @el.off('click', '.trading .material', @.onTradingMaterialClick)
    @el.off('click', '.improvement .material', @.onImprovementMaterialClick)
    @el.off('click', '.bonus .collect:not(.disabled)', @.onBonusCollectClick)

  defineData: ->
    @townLevel = TownLevel.findByNumber(@player.town_level)


  onImprovementMaterialClick: (e)=>
    materialEl = $(e.currentTarget)

    @.displayPopup(materialEl
      @.renderTemplate('town/material_progress_popup',
        current: @playerState.getMaterialFor('town', materialEl.data('material'))
        max: @townLevel.getMaterial(materialEl.data('material'))
      )
      position: 'top center'
      autoHideDelay: _(5).seconds()
      autoHide: true
    )

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

  onBonusCollectClick: (e)->
    $(e.currentTarget).addClass('disabled')

    request.send('collect_town_bonus')

  onBonusCollected: (response)=>
    console.log response

  firstDeliveredMaterial: ->
    for materialKey, record of @playerState.townMaterialRecords()
      return record if record.isDeliveredToday()

  isMaterialDeliveredToday: ->
    return true if @.firstDeliveredMaterial()?

    false

  progressForMaterial: (materialKey)->
    @playerState.getMaterialFor('town', materialKey) / @townLevel.getMaterial(materialKey) * 100

  bonusReward: ->
    {basic_money: @townLevel.bonusBasicMoney()}

module.exports = TownPage
