Page = require("../page")
Pagination = require("../../lib").Pagination
modals = require('../modals')
request = require('../../lib/request')
VisualTimer = require("../../lib").VisualTimer
ctx = require('../../context')

PropertyType = require('../../game_data').PropertyType
Property = require('../../game_data').Property

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
      property = _.find(@properties, (p)-> p.typeId == resource.id)
      continue unless property?

      if property.isBuilding()
        @timers[resource.id] ?= new VisualTimer()
        @timers[resource.id].setElement($("#property_type_#{ resource.id } .timer .value"))
        @timers[resource.id].start(property.actualBuildingTimeLeft())

  bindEventListeners: ->
    super

    @playerState.bind('update', @.onStateUpdated)

    request.bind('property_created', @.onPropertyCreated)

    @el.on('click', '.list .paginate:not(.disabled)', @.onListPaginateClick)
    @el.on('click', '.switches .switch', @.onSwitchPageClick)

    @el.on('click', '.property .build:not(.disabled)', @.onBuildClick)
    @el.on('click', '.property .start_build:not(.disabled)', @.onStartBuildClick)
    @el.on('click', '.property .accelerate:not(.disabled)', @.onAccelerateClick)

  unbindEventListeners: ->
    super

    @playerState.unbind('update', @.onStateUpdated)

    request.unbind('property_created', @.onPropertyCreated)

    @el.off('click', '.list .paginate:not(.disabled)', @.onListPaginateClick)
    @el.off('click', '.switches .switch', @.onSwitchPageClick)

    @el.off('click', '.property .build:not(.disabled)', @.onBuildClick)
    @el.off('click', '.property .start_build:not(.disabled)', @.onStartBuildClick)
    @el.off('click', '.property .accelerate:not(.disabled)', @.onAccelerateClick)

  defineData: ->
    @properties = (
      for id, data of @playerState.properties
        new Property(_.assignIn({id: id}, data))
    )

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
    property = _.find(@list, (t)-> t.id == button.data('type-id'))

    @.displayPopup(button,
      @.renderTemplate("properties/build_popup", property: property)
      position: 'left bottom'
    )

  onStartBuildClick: (e)->
    button = $(e.currentTarget)
    button.addClass('disabled')
    $("#property_type_#{ button.data('type-id') } button.build").addClass('disabled')

    request.send("create_property", property_type_id: button.data('type-id'))

  buildPriceRequirement: (type)->
    {basic_money: [@.formatNumber(type.basicPrice), @player.basic_money >= type.basicPrice]}

  acceleratePriceRequirement: (type)->
    {vip_money: [@.formatNumber(type.basicPrice), @player.basic_money >= type.basicPrice]}


  onStateUpdated: =>
    console.log @playerState.properties

  onPropertyCreated: (response)=>
    console.log 'onPropertyCreated'

  onAccelerateClick: (e)=>
    button = $(e.currentTarget)
    property = _.find(@list, (t)-> t.id == button.data('type-id'))

    @.displayPopup($(e.currentTarget)
      @.renderTemplate("properties/accelerate_popup", property: property)
      position: 'left bottom'
    )

module.exports = PropertiesPage
