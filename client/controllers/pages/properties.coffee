Page = require("../page")
Pagination = require("../../lib").Pagination
modals = require('../modals')
request = require('../../lib/request')
VisualTimer = require("../../lib").VisualTimer
ctx = require('../../context')
balance = require('../../lib').balance

PropertyType = require('../../game_data').PropertyType

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
    for resource in @paginatedList
      property = _.find(@playerState.getProperties(), (p)-> p.typeId == resource.id)
      continue unless property?

      if property.isBuilding()
        @timers[resource.id] ?= new VisualTimer()
        @timers[resource.id].setElement($("#property_type_#{ resource.id } .timer .value"))
        @timers[resource.id].start(property.actualBuildingTimeLeft())

  bindEventListeners: ->
    super

    @playerState.bind('update', @.onStateUpdated)

    request.bind('property_created', @.onPropertyCreated)
    request.bind('property_accelerated', @.onPropertyAccelerated)

    @el.on('click', '.list .paginate:not(.disabled)', @.onListPaginateClick)
    @el.on('click', '.switches .switch', @.onSwitchPageClick)

    @el.on('click', '.property .build:not(.disabled)', @.onBuildClick)
    @el.on('click', '.property .start_build:not(.disabled)', @.onStartBuildClick)
    @el.on('click', '.property .accelerate:not(.disabled)', @.onAccelerateClick)
    @el.on('click', '.property .start_accelerate:not(.disabled)', @.onStartAccelerateClick)

  unbindEventListeners: ->
    super

    @playerState.unbind('update', @.onStateUpdated)

    request.unbind('property_created', @.onPropertyCreated)
    request.unbind('property_accelerated', @.onPropertyAccelerated)

    @el.off('click', '.list .paginate:not(.disabled)', @.onListPaginateClick)
    @el.off('click', '.switches .switch', @.onSwitchPageClick)

    @el.off('click', '.property .build:not(.disabled)', @.onBuildClick)
    @el.off('click', '.property .start_build:not(.disabled)', @.onStartBuildClick)
    @el.off('click', '.property .accelerate:not(.disabled)', @.onAccelerateClick)
    @el.off('click', '.property .start_accelerate:not(.disabled)', @.onStartAccelerateClick)

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

  buildPriceRequirement: (type)->
    {basic_money: [@.formatNumber(type.basicPrice), @player.basic_money >= type.basicPrice]}

  acceleratePriceRequirement: (property)->
    price = (
      if property.isBuilding()
        balance.acceleratePrice(property.actualBuildingTimeLeft())
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
    @.displayResult(
      $("#property_type_#{ response.data.type_id } .result_anchor")
      response
      position: "top center"
    )

    if response.is_error
      $("#property_type_#{ response.data.type_id } .controls button").removeClass('disabled')

  onAccelerateClick: (e)=>
    button = $(e.currentTarget)
    property = _.find(@playerState.getProperties(), (p)-> p.id == button.data('property-id'))

    @.displayPopup(button
      @.renderTemplate("properties/accelerate_popup", property: property)
      position: 'left bottom'
    )

  onStartAccelerateClick: (e)->
    button = $(e.currentTarget)
    button.addClass('disabled')
    $("#property_type_#{ button.data('type-id') } button.accelerate").addClass('disabled')

    request.send("accelerate_property", property_id: button.data('property-id'))

  onPropertyAccelerated: (response)=>
    @.displayResult(
      $("#property_type_#{ response.data.type_id } .result_anchor") if response.data?.type_id?
      response
      position: "top center"
    )

    if response.is_error
      $("#property_type_#{ response.data?.type_id } .controls button").removeClass('disabled')

module.exports = PropertiesPage
