Page = require("../page")
Pagination = require("../../lib").Pagination
modals = require('../modals')
request = require('../../lib/request')
VisualTimer = require("../../lib").VisualTimer
ctx = require('../../context')
balance = require('../../lib').balance

gameData = require('../../game_data')

FactoryType = gameData.FactoryType

class FactoriesPage extends Page
  className: "factories page"

  PER_PAGE = 4

  show: ->
    @playerState = ctx.get('playerState')

    super

    @timers = {}

    @.defineData()

    @.render()

  hide: ->
    for id, timer of @timers
      timer.stop()

    super

  render: ->
    @html(@.renderTemplate("factories/index"))

    @.setupTimers()

  renderList: ->
    @el.find('.list').html(@.renderTemplate("factories/list"))

    @.setupTimers()

  setupTimers: ->
    for factoryType in @paginatedList
      factory = _.find(@playerState.factoryRecords(), (p)-> p.factoryTypeId == factoryType.id)
      continue unless factory?

      if factory.isBuilding()
        @timers[factoryType.id] ?= new VisualTimer(null, => @.renderList())
        @timers[factoryType.id].setElement($("#factory_type_#{ factoryType.id } .timer .value"))
        @timers[factoryType.id].start(factory.actualBuildingTimeLeft())

      else if factory.isUpgrading()
        @timers[factoryType.id] ?= new VisualTimer(null, => @.renderList())
        @timers[factoryType.id].setElement($("#factory_type_#{ factoryType.id } .timer .value"))
        @timers[factoryType.id].start(factory.actualUpgradingTimeLeft())

  bindEventListeners: ->
    super

    @playerState.bind('update', @.onStateUpdated)

    request.bind('factory_created', @.onFactoryCreated)
    request.bind('factory_accelerated', @.onFactoryAccelerated)
    request.bind('factory_upgraded', @.onFactoryUpgraded)

    @el.on('click', '.list .paginate:not(.disabled)', @.onListPaginateClick)
    @el.on('click', '.switches .switch', @.onSwitchPageClick)
    @el.on('click', '.factory .build:not(.disabled)', @.onBuildClick)
    @el.on('click', '.factory .start_build:not(.disabled)', @.onStartBuildClick)
    @el.on('click', '.factory .accelerate:not(.disabled)', @.onAccelerateClick)
    @el.on('click', '.factory .start_accelerate:not(.disabled)', @.onStartAccelerateClick)
    @el.on('click', '.factory .upgrade:not(.disabled)', @.onUpgradeClick)
    @el.on('click', '.factory .start_upgrade:not(.disabled)', @.onStartUpgradeClick)
    @el.on('click', '.factory .info-icon', @.onInfoClick)
    @el.on('click', '.factory .start:not(.disabled)', @.onStartClick)

  unbindEventListeners: ->
    super

    @playerState.unbind('update', @.onStateUpdated)

    request.unbind('factory_created', @.onFactoryCreated)
    request.unbind('factory_accelerated', @.onFactoryAccelerated)
    request.unbind('factory_upgraded', @.onFactoryUpgraded)

    @el.off('click', '.list .paginate:not(.disabled)', @.onListPaginateClick)
    @el.off('click', '.switches .switch', @.onSwitchPageClick)
    @el.off('click', '.factory .build:not(.disabled)', @.onBuildClick)
    @el.off('click', '.factory .start_build:not(.disabled)', @.onStartBuildClick)
    @el.off('click', '.factory .accelerate:not(.disabled)', @.onAccelerateClick)
    @el.off('click', '.factory .start_accelerate:not(.disabled)', @.onStartAccelerateClick)
    @el.off('click', '.factory .upgrade:not(.disabled)', @.onUpgradeClick)
    @el.off('click', '.factory .start_upgrade:not(.disabled)', @.onStartUpgradeClick)
    @el.off('click', '.factory .info-icon', @.onInfoClick)
    @el.off('click', '.factory .start:not(.disabled)', @.onStartClick)

  defineData: ->
    @list = FactoryType.all()
    @listPagination = new Pagination(PER_PAGE)
    @paginatedList = @listPagination.paginate(@list, initialize: true)

    @listPagination.setSwitches(@list)

  onListPaginateClick: (e)=>
    @paginatedList = @listPagination.paginate(@list,
      back: $(e.currentTarget).data('type') == 'back'
    )

    @.renderList()

  onSwitchPageClick: (e)=>
    @paginatedList = @listPagination.paginate(@list,
      start_count: ($(e.currentTarget).data('page') - 1) * @listPagination.per_page
    )

    @.renderList()

  onBuildClick: (e)=>
    button = $(e.currentTarget)
    factoryType = _.find(@list, (t)-> t.id == button.data('type-id'))

    @.displayPopup(button,
      @.renderTemplate("factories/build_popup", factoryType: factoryType)
      position: 'left bottom'
    )

  onStartBuildClick: (e)->
    button = $(e.currentTarget)
    button.addClass('disabled')
    $("#factory_type_#{ button.data('type-id') } button.build").addClass('disabled')

    request.send("create_factory", factory_type_id: button.data('type-id'))

  buildPriceRequirement: (type, factory)->
    {basic_money: [@.formatNumber(type.basicPrice), @player.basic_money >= type.basicPrice]}

  upgradePriceRequirement: (type, factory)->
    price = type.upgradePriceBy(factory.level)

    {basic_money: [@.formatNumber(price), @player.basic_money >= price]}

  acceleratePriceRequirement: (factory)->
    price = (
      if factory.isBuilding()
        balance.acceleratePrice(factory.actualBuildingTimeLeft())
      else if factory.isUpgrading()
        balance.acceleratePrice(factory.actualUpgradingTimeLeft())
      else
        999
    )

    {vip_money: [@.formatNumber(price), @player.vip_money >= price]}

  onStateUpdated: =>
    changes = @playerState.changes()

    return unless changes.factories?

    @.renderList()

  onFactoryCreated: (response)=>
    @.handleResponse(response)

  onAccelerateClick: (e)=>
    button = $(e.currentTarget)
    factory = _.find(@playerState.factoryRecords(), (p)-> p.id == button.data('factory-id'))

    @.displayPopup(button
      @.renderTemplate("factories/accelerate_popup", factory: factory)
      position: 'left bottom'
    )

  onStartAccelerateClick: (e)=>
    button = $(e.currentTarget)
    button.addClass('disabled')
    factory = @playerState.findFactoryRecord(button.data('factory-id'))

    $("#factory_type_#{ factory.factoryTypeId } button.accelerate").addClass('disabled')

    request.send("accelerate_factory", factory_id: button.data('factory-id'))

  onFactoryAccelerated: (response)=>
    @.handleResponse(response)

  onUpgradeClick: (e)=>
    button = $(e.currentTarget)
    factory = @playerState.findFactoryRecord(button.data('factory-id'))
    factoryType = _.find(@list, (t)-> t.id == factory.factoryTypeId)

    @.displayPopup(button
      @.renderTemplate("factories/upgrade_popup", factory: factory, factoryType: factoryType)
      position: 'left bottom'
    )

  onStartUpgradeClick: (e)=>
    button = $(e.currentTarget)
    button.addClass('disabled')
    factory = @playerState.findFactoryRecord(button.data('factory-id'))

    $("#factory_type_#{ factory.factoryTypeId } button.upgrade").addClass('disabled')

    request.send("upgrade_factory", factory_id: button.data('factory-id'))

  onFactoryUpgraded: (response)=>
    @.handleResponse(response)

  onInfoClick: (e)=>
    button = $(e.currentTarget)
    factoryType = _.find(@list, (t)-> t.id == button.data('type-id'))

    @.displayPopup(button
      "<div class='description'>#{factoryType.description()}</div>"
      position: 'left bottom'
      autoHideDelay: _(10).seconds()
      autoHide: true
    )

  onStartClick: (e)->
    modals.StartFactoryModal.show($(e.currentTarget).data('factory-id'))

  handleResponse: (response)->
    @.displayResult(
      $("#factory_type_#{ response.data.factory_type_id } .result_anchor") if response.data?.factory_type_id?
      response
      position: "top center"
    )

    if response.is_error
      $("#factory_type_#{ response.data?.factory_type_id } .controls button").removeClass('disabled')

module.exports = FactoriesPage
