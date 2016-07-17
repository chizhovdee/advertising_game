Page = require("../page")
Pagination = require("../../lib").Pagination
modals = require('../modals')
request = require('../../lib/request')
VisualTimer = require("../../lib").VisualTimer
ctx = require('../../context')
balance = require('../../lib').balance
settings = require('../../settings')

PropertyType = require('../../game_data').PropertyType

class PropertiesPage extends Page
  className: "properties page"

  PER_PAGE = 4

  show: ->
    @playerState = ctx.get('playerState')

    @settings = settings

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
    for resource in @paginatedList
      property = _.find(@playerState.getProperties(), (p)-> p.typeId == resource.id)
      continue unless property?

      if property.isBuilding()
        @timers[resource.id] ?= new VisualTimer(null, => @.renderList())
        @timers[resource.id].setElement($("#property_type_#{ resource.id } .timer .value"))
        @timers[resource.id].start(property.actualBuildingTimeLeft())

      else if property.isUpgrading()
        @timers[resource.id] ?= new VisualTimer(null, => @.renderList())
        @timers[resource.id].setElement($("#property_type_#{ resource.id } .timer .value"))
        @timers[resource.id].start(property.actualUpgradingTimeLeft())

      else if property.isRented() && !property.rentFinished()
        @timers[resource.id] ?= new VisualTimer(null, => @.renderList())
        @timers[resource.id].setElement($("#property_type_#{ resource.id } .timer .value"))
        @timers[resource.id].start(property.actualRentTimeLeft())

  bindEventListeners: ->
    super

    @playerState.bind('update', @.onStateUpdated)

    request.bind('property_created', @.onPropertyCreated)
    request.bind('property_accelerated', @.onPropertyAccelerated)
    request.bind('property_upgraded', @.onPropertyUpgraded)
    request.bind('property_rented', @.onPropertyRented)
    request.bind('property_rent_collected', @.onPropertyRentCollected)
    request.bind('property_rent_finished', @.onPropertyRentFinished)

    @el.on('click', '.list .paginate:not(.disabled)', @.onListPaginateClick)
    @el.on('click', '.switches .switch', @.onSwitchPageClick)
    @el.on('click', '.property .build:not(.disabled)', @.onBuildClick)
    @el.on('click', '.property .start_build:not(.disabled)', @.onStartBuildClick)
    @el.on('click', '.property .accelerate:not(.disabled)', @.onAccelerateClick)
    @el.on('click', '.property .start_accelerate:not(.disabled)', @.onStartAccelerateClick)
    @el.on('click', '.property .upgrade:not(.disabled)', @.onUpgradeClick)
    @el.on('click', '.property .start_upgrade:not(.disabled)', @.onStartUpgradeClick)
    @el.on('click', '.property .info-icon', @.onInfoClick)
    @el.on('click', '.property .rent_out:not(.disabled)', @.onRentOutClick)
    @el.on('click', '.property .start_rent_out:not(.disabled)', @.onStartRentOutClick)
    @el.on('click', '.property .collect_rent:not(.disabled)', @.onCollectRentClick)
    @el.on('click', '.property .finish_rent:not(.disabled)', @.onFinishRentClick)
    @el.on('click', '.property .start_finishing_rent:not(.disabled)', @.onStartFinishingRentClick)

  unbindEventListeners: ->
    super

    @playerState.unbind('update', @.onStateUpdated)

    request.unbind('property_created', @.onPropertyCreated)
    request.unbind('property_accelerated', @.onPropertyAccelerated)
    request.unbind('property_upgraded', @.onPropertyUpgraded)
    request.unbind('property_rented', @.onPropertyRented)
    request.unbind('property_rent_collected', @.onPropertyRentCollected)
    request.unbind('property_rent_finished', @.onPropertyRentFinished)

    @el.off('click', '.list .paginate:not(.disabled)', @.onListPaginateClick)
    @el.off('click', '.switches .switch', @.onSwitchPageClick)
    @el.off('click', '.property .build:not(.disabled)', @.onBuildClick)
    @el.off('click', '.property .start_build:not(.disabled)', @.onStartBuildClick)
    @el.off('click', '.property .accelerate:not(.disabled)', @.onAccelerateClick)
    @el.off('click', '.property .start_accelerate:not(.disabled)', @.onStartAccelerateClick)
    @el.off('click', '.property .upgrade:not(.disabled)', @.onUpgradeClick)
    @el.off('click', '.property .start_upgrade:not(.disabled)', @.onStartUpgradeClick)
    @el.off('click', '.property .info-icon', @.onInfoClick)
    @el.off('click', '.property .rent_out:not(.disabled)', @.onRentOutClick)
    @el.off('click', '.property .start_rent_out:not(.disabled)', @.onStartRentOutClick)
    @el.off('click', '.property .collect_rent:not(.disabled)', @.onCollectRentClick)
    @el.off('click', '.property .finish_rent:not(.disabled)', @.onFinishRentClick)
    @el.off('click', '.property .start_finishing_rent:not(.disabled)', @.onStartFinishingRentClick)

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
    console.log 'PlayerState', @playerState.changes()

    changes = @playerState.changes()

    return unless changes.properties?

    @.renderList()

  onPropertyCreated: (response)=>
    @.handleResponse(response)

  onAccelerateClick: (e)=>
    button = $(e.currentTarget)
    property = _.find(@playerState.getProperties(), (p)-> p.id == button.data('property-id'))

    @.displayPopup(button
      @.renderTemplate("properties/accelerate_popup", property: property)
      position: 'left bottom'
    )

  onStartAccelerateClick: (e)=>
    button = $(e.currentTarget)
    button.addClass('disabled')
    property = @playerState.findProperty(button.data('property-id'))

    $("#property_type_#{ property.typeId } button.accelerate").addClass('disabled')

    request.send("accelerate_property", property_id: button.data('property-id'))

  onPropertyAccelerated: (response)=>
    @.handleResponse(response)

  onUpgradeClick: (e)=>
    button = $(e.currentTarget)
    property = @playerState.findProperty(button.data('property-id'))
    propertyType = _.find(@list, (t)-> t.id == property.typeId)

    @.displayPopup(button
      @.renderTemplate("properties/upgrade_popup", property: property, propertyType: propertyType)
      position: 'left bottom'
    )

  onStartUpgradeClick: (e)=>
    button = $(e.currentTarget)
    button.addClass('disabled')
    property = @playerState.findProperty(button.data('property-id'))

    $("#property_type_#{ property.typeId } button.upgrade").addClass('disabled')

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

  onRentOutClick: (e)=>
    button = $(e.currentTarget)
    property = @playerState.findProperty(button.data('property-id'))
    propertyType = _.find(@list, (t)-> t.id == property.typeId)

    @.displayPopup(button
      @.renderTemplate("properties/rent_out_popup", property: property, propertyType: propertyType)
      position: 'top center'
    )

  onStartRentOutClick: (e)=>
    button = $(e.currentTarget)
    button.addClass('disabled')
    property = @playerState.findProperty(button.data('property-id'))

    $("#property_type_#{ property.typeId } button.rent_out").addClass('disabled')

    request.send("rent_out_property", property_id: button.data('property-id'))

  onPropertyRented: (response)=>
    @.handleResponse(response)

  onCollectRentClick: (e)=>
    button = $(e.currentTarget)
    button.addClass('disabled')
    property = @playerState.findProperty(button.data('property-id'))

    request.send("property_collect_rent", property_id: button.data('property-id'))

  onPropertyRentCollected: (response)=>
    @.handleResponse(response)

  onFinishRentClick: (e)=>
    button =$ (e.currentTarget)

    @.displayConfirm(button,
      message: I18n.t("properties.property.confirm_finish_rent")
      button:
        className: 'start_finishing_rent'
        data:
          'property-id': _.toInteger(button.data('property-id'))
      position: 'left bottom'
    )

  onStartFinishingRentClick: (e)=>
    button = $(e.currentTarget)
    return if button.data('type') == 'cancel'

    button.addClass('disabled')
    property_id = button.parents('.confirm_controls').data('property-id')
    property = @playerState.findProperty(property_id)

    $("#property_type_#{ property.typeId } button.finish_rent").addClass('disabled')

    request.send("property_finish_rent", property_id: property_id)

  onPropertyRentFinished: (response)=>
    @.handleResponse(response)

  handleResponse: (response)->
    @.displayResult(
      $("#property_type_#{ response.data.type_id } .result_anchor") if response.data?.type_id?
      response
      position: "top center"
    )

    if response.is_error
      $("#property_type_#{ response.data?.type_id } .controls button").removeClass('disabled')

module.exports = PropertiesPage
