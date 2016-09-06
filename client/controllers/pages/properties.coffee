Page = require("../page")
Pagination = require("../../lib").Pagination
modals = require('../modals')
request = require('../../lib/request')
VisualTimer = require("../../lib").VisualTimer
ctx = require('../../context')
balance = require('../../lib').balance

gameData = require('../../game_data')

PropertyType = gameData.PropertyType

class PropertiesPage extends Page
  className: "properties page"

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
    @html(@.renderTemplate("properties/index"))

    @.setupTimers()

  renderList: ->
    @el.find('.list').html(@.renderTemplate("properties/list"))

    @.setupTimers()

  setupTimers: ->
    for propertyType in @paginatedList
      property = _.find(@playerState.propertyRecords(), (p)-> p.propertyTypeId == propertyType.id)
      continue unless property?

      if property.isBuilding()
        @timers[propertyType.id] ?= new VisualTimer(null, => @.renderList())
        @timers[propertyType.id].setElement($("#property_type_#{ propertyType.id } .timer .value"))
        @timers[propertyType.id].start(property.actualBuildingTimeLeft())

      else if property.isUpgrading()
        @timers[propertyType.id] ?= new VisualTimer(null, => @.renderList())
        @timers[propertyType.id].setElement($("#property_type_#{ propertyType.id } .timer .value"))
        @timers[propertyType.id].start(property.actualUpgradingTimeLeft())

  bindEventListeners: ->
    super

    @playerState.bind('update', @.onStateUpdated)

    request.bind('property_created', @.onPropertyCreated)
    request.bind('property_accelerated', @.onPropertyAccelerated)
    request.bind('property_upgraded', @.onPropertyUpgraded)

    @el.on('click', '.list .paginate:not(.disabled)', @.onListPaginateClick)
    @el.on('click', '.switches .switch', @.onSwitchPageClick)
    @el.on('click', '.property .build:not(.disabled)', @.onBuildClick)
    @el.on('click', '.property .start_build:not(.disabled)', @.onStartBuildClick)
    @el.on('click', '.property .accelerate:not(.disabled)', @.onAccelerateClick)
    @el.on('click', '.property .start_accelerate:not(.disabled)', @.onStartAccelerateClick)
    @el.on('click', '.property .upgrade:not(.disabled)', @.onUpgradeClick)
    @el.on('click', '.property .start_upgrade:not(.disabled)', @.onStartUpgradeClick)
    @el.on('click', '.property .info-icon', @.onInfoClick)

  unbindEventListeners: ->
    super

    @playerState.unbind('update', @.onStateUpdated)

    request.unbind('property_created', @.onPropertyCreated)
    request.unbind('property_accelerated', @.onPropertyAccelerated)
    request.unbind('property_upgraded', @.onPropertyUpgraded)

    @el.off('click', '.list .paginate:not(.disabled)', @.onListPaginateClick)
    @el.off('click', '.switches .switch', @.onSwitchPageClick)
    @el.off('click', '.property .build:not(.disabled)', @.onBuildClick)
    @el.off('click', '.property .start_build:not(.disabled)', @.onStartBuildClick)
    @el.off('click', '.property .accelerate:not(.disabled)', @.onAccelerateClick)
    @el.off('click', '.property .start_accelerate:not(.disabled)', @.onStartAccelerateClick)
    @el.off('click', '.property .upgrade:not(.disabled)', @.onUpgradeClick)
    @el.off('click', '.property .start_upgrade:not(.disabled)', @.onStartUpgradeClick)
    @el.off('click', '.property .info-icon', @.onInfoClick)

  defineData: ->
    @list = PropertyType.all()
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
    propertyType = _.find(@list, (t)-> t.id == button.data('type-id'))

    @.displayPopup(button,
      @.renderTemplate("properties/build_popup", propertyType: propertyType)
      position: 'left bottom'
    )

  onStartBuildClick: (e)->
    button = $(e.currentTarget)
    button.addClass('disabled')
    $("#property_type_#{ button.data('type-id') } button.build").addClass('disabled')

    request.send("create_property", property_type_id: button.data('type-id'))

  buildPriceRequirement: (type, property)->
    {basic_money: [@.formatNumber(type.basicPrice), @player.basic_money >= type.basicPrice]}

  upgradePriceRequirement: (type, property)->
    price = type.upgradePriceBy(property.level)

    {basic_money: [@.formatNumber(price), @player.basic_money >= price]}

  acceleratePriceRequirement: (property)->
    price = (
      if property.isBuilding()
        balance.acceleratePrice(property.actualBuildingTimeLeft())
      else if property.isUpgrading()
        balance.acceleratePrice(property.actualUpgradingTimeLeft())
      else
        999
    )

    {vip_money: [@.formatNumber(price), @player.vip_money >= price]}

  onStateUpdated: =>
    changes = @playerState.changes()

    return unless changes.properties?

    @.renderList()

  onPropertyCreated: (response)=>
    @.handleResponse(response)

  onAccelerateClick: (e)=>
    button = $(e.currentTarget)
    property = _.find(@playerState.propertyRecords(), (p)-> p.id == button.data('property-id'))

    @.displayPopup(button
      @.renderTemplate("properties/accelerate_popup", property: property)
      position: 'left bottom'
    )

  onStartAccelerateClick: (e)=>
    button = $(e.currentTarget)
    button.addClass('disabled')
    property = @playerState.findPropertyRecord(button.data('property-id'))

    $("#property_type_#{ property.propertyTypeId } button.accelerate").addClass('disabled')

    request.send("accelerate_property", property_id: button.data('property-id'))

  onPropertyAccelerated: (response)=>
    @.handleResponse(response)

  onUpgradeClick: (e)=>
    button = $(e.currentTarget)
    property = @playerState.findPropertyRecord(button.data('property-id'))
    propertyType = _.find(@list, (t)-> t.id == property.propertyTypeId)

    @.displayPopup(button
      @.renderTemplate("properties/upgrade_popup", property: property, propertyType: propertyType)
      position: 'left bottom'
    )

  onStartUpgradeClick: (e)=>
    button = $(e.currentTarget)
    button.addClass('disabled')
    property = @playerState.findPropertyRecord(button.data('property-id'))

    $("#property_type_#{ property.propertyTypeId } button.upgrade").addClass('disabled')

    request.send("upgrade_property", property_id: button.data('property-id'))

  onPropertyUpgraded: (response)=>
    @.handleResponse(response)

  onInfoClick: (e)=>
    button = $(e.currentTarget)
    propertyType = _.find(@list, (t)-> t.id == button.data('type-id'))

    @.displayPopup(button
      "<div class='description'>#{propertyType.description()}</div>"
      position: 'left bottom'
      autoHideDelay: _(10).seconds()
      autoHide: true
    )

  handleResponse: (response)->
    @.displayResult(
      $("#property_type_#{ response.data.property_type_id } .result_anchor") if response.data?.property_type_id?
      response
      position: "top center"
    )

    if response.is_error
      $("#property_type_#{ response.data?.property_type_id } .controls button").removeClass('disabled')

  usingCapacity: (propertyType)->
    switch propertyType.key
      when 'garage'
        @playerState.transportCount()

      when 'command_center'
        @playerState.advertisingCount()
      else
        0

module.exports = PropertiesPage
