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
      @timers.dailyLimit ?= new VisualTimer(null, => @.render())
      @timers.dailyLimit.setElement($(".trading .timer .value"))
      @timers.dailyLimit.start(record.actualTimeLeftToLimit())

    unless @town.canCollectBonus()
      @timers.bonus ?= new VisualTimer(null, => @.render())
      @timers.bonus.setElement($(".bonus .timer .value"))
      @timers.bonus.start(@town.timeLeftToCollectBonus())

    if @town.isUpgrading()
      @timers.improvement ?= new VisualTimer(null, => @.render())
      @timers.improvement.setElement($(".upgrading .timer .value"))
      @timers.improvement.start(@town.timeLeftToUpgrading())

  bindEventListeners: ->
    super

    @player.bind('update', @.onPlayerUpdated)
    @playerState.bind('update', @.onStateUpdated)

    request.bind('town_bonus_collected', @.onBonusCollected)
    request.bind('town_upgraded', @.onUpgraded)
    request.bind('town_accelerated', @.onAccelerated)

    @el.on('click', '.trading .material', @.onTradingMaterialClick)
    @el.on('click', '.improvement .material', @.onImprovementMaterialClick)
    @el.on('click', '.bonus .collect:not(.disabled)', @.onBonusCollectClick)
    @el.on('click', '.upgrade:not(.disabled)', @.onUpgradeClick)
    @el.on('click', '.start_upgrade:not(.disabled)', @.onStartUpgradeClick)
    @el.on('click', '.accelerate:not(.disabled)', @.onAccelerateClick)
    @el.on('click', '.start_accelerate:not(.disabled)', @.onStartAccelerateClick)

  unbindEventListeners: ->
    super

    @player.unbind('update', @.onPlayerUpdated)
    @playerState.unbind('update', @.onStateUpdated)

    request.unbind('town_bonus_collected', @.onBonusCollected)
    request.unbind('town_upgraded', @.onUpgraded)
    request.unbind('town_accelerated', @.onAccelerated)

    @el.off('click', '.trading .material', @.onTradingMaterialClick)
    @el.off('click', '.improvement .material', @.onImprovementMaterialClick)
    @el.off('click', '.bonus .collect:not(.disabled)', @.onBonusCollectClick)
    @el.off('click', '.upgrade:not(.disabled)', @.onUpgradeClick)
    @el.off('click', '.start_upgrade:not(.disabled)', @.onStartUpgradeClick)
    @el.off('click', '.accelerate:not(.disabled)', @.onAccelerateClick)
    @el.off('click', '.start_accelerate:not(.disabled)', @.onStartAccelerateClick)

  defineData: ->
    console.log @town = @playerState.findPlaceRecord('town')
    console.log @townResource = @playerState.getResourceFor(@town)
    @townLevel = @town.level()

  onImprovementMaterialClick: (e)=>
    materialEl = $(e.currentTarget)

    @.displayPopup(materialEl
      @.renderTemplate('town/material_progress_popup',
        current: @playerState.getMaterialFor(@townResource, materialEl.data('material'))
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
    @.displayResult(null, response)

    if response.is_error
      @el.find('.bonus .collect').removeClass('disabled')

  onPlayerUpdated: (player)=>
    changes = player.changes()

    if changes.town_level? ||
       changes.town_upgrade_at? ||
       changes.town_bonus_collected_at?
      @.render()

  onStateUpdated: (playerState)=>
    changes = playerState.changes()

    if changes.townMaterials? || changes.materials?
      @.render()

  onUpgradeClick: (e)=>
    @.displayConfirm($(e.currentTarget),
      button:
        className: 'start_upgrade'
      position: 'right bottom'
    )

  onStartUpgradeClick: (e)=>
    $(e.currentTarget).addClass('disabled')

    @el.find('.improvement .upgrade').addClass('disabled')

    request.send('upgrade_town')

  onAccelerateClick: (e)=>
    @.displayPopup($(e.currentTarget)
      @.renderTemplate("town/accelerate_popup", town: @town)
      position: 'left bottom'
    )


  onStartAccelerateClick: (e)=>
    $(e.currentTarget).addClass('disabled')

    @el.find('.upgrading .accelerate').addClass('disabled')

    request.send('accelerate_town')

  onUpgraded: (response)=>
    @.displayResult(null, response)

    if response.is_error
      @el.find('.improvement .upgrade').removeClass('disabled')

  onAccelerated: (response)=>
    @.displayResult(null, response)

    if response.is_error
      @el.find('.upgrading .accelerate').removeClass('disabled')

  firstDeliveredMaterial: ->
    for materialKey, record of @playerState.townMaterialRecords()
      return record if record.isDeliveredToday()

  isMaterialDeliveredToday: ->
    return true if @.firstDeliveredMaterial()?

    false

  progressForMaterial: (materialKey)->
    @playerState.getMaterialFor(@townResource, materialKey) / @townLevel.getMaterial(materialKey) * 100

  bonusReward: ->
    {basic_money: @townLevel.bonusBasicMoney()}

  acceleratePriceRequirement: ->
    price = balance.acceleratePrice(@town.timeLeftToUpgrading())

    {vip_money: [@.formatNumber(price), @player.vip_money >= price]}

module.exports = TownPage
