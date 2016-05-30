Page = require("../page")
Pagination = require("../../lib").Pagination
modals = require('../modals')
request = require('../../lib/request')
VisualTimer = require("../../lib").VisualTimer
ctx = require('../../context')

PropertyType = require('../../game_data').PropertyType

class PropertiesPage extends Page
  className: "properties page"

  PER_PAGE = 3

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
    timeDiff = Date.now() - @playerState.propertiesUpdatedAt

    for resource in @paginatedList
      property = _.find(@properties, (p)-> p.typeId == resource.id)
      continue unless property?

      if property.buildingTimeLeft? && property.buildingTimeLeft > 0
        @timers[resource.id] ?= new VisualTimer()
        @timers[resource.id].setElement($("#property_type_#{ resource.id } .timer .value"))
        @timers[resource.id].start(property.buildingTimeLeft - timeDiff)

  bindEventListeners: ->
    super

    request.bind('property_created', @.onPropertyCreated)

    @el.on('click', '.list .paginate:not(.disabled)', @.onListPaginateClick)
    @el.on('click', '.switches .switch', @.onSwitchPageClick)

    @el.on('click', '.property .build:not(.disabled)', @.onBuildClick)
    @el.on('click', '.property .start_build:not(.disabled)', @.onStartBuildClick)

    @playerState.bind('update', @.onStateUpdated)

  unbindEventListeners: ->
    super

    request.unbind('property_created', @.onPropertyCreated)

    @el.off('click', '.list .paginate:not(.disabled)', @.onListPaginateClick)
    @el.off('click', '.switches .switch', @.onSwitchPageClick)

    @el.off('click', '.property .build:not(.disabled)', @.onBuildClick)
    @el.off('click', '.property .start_build:not(.disabled)', @.onStartBuildClick)

    @playerState.unbind('update', @.onStateUpdated)

  defineData: ->
    console.log @properties = @playerState.properties

    console.log @list = PropertyType.all()

    @listPagination = new Pagination(PER_PAGE)
    @paginatedList = @listPagination.paginate(@list, initialize: true)

    @listPagination.setSwitches(@list)

  onListPaginateClick: (e)=>
    @paginatedList = @listPagination.paginate(@list,
      back: $(e.currentTarget).data('type') == 'back'
    )

    @.renderList()

    @.setupTimers()

  onSwitchPageClick: (e)=>
    @paginatedList = @listPagination.paginate(@list,
      start_count: ($(e.currentTarget).data('page') - 1) * @listPagination.per_page
    )

    @.renderList()

    @.setupTimers()

  onBuildClick: (e)=>
    button = $(e.currentTarget)
    property = _.find(@list, (t)-> t.id == button.data('type-id'))

    @.displayPopup($(e.currentTarget)
      @.renderTemplate("properties/build_popup", property: property)
      position: 'left bottom'
      alterClassName: 'property_build_popup'
    )

  onStartBuildClick: (e)->
    button = $(e.currentTarget)
    button.addClass('disabled')
    $("#property_type_#{ button.data('type-id') } button.build").addClass('disabled')

    request.send("create_property", property_type_id: button.data('type-id'))

  buildPriceRequirement: (type)->
    {basic_money: [type.basicPrice, @player.basic_money >= type.basicPrice]}

  onStateUpdated: =>
    console.log @playerState.properties

  onPropertyCreated: (response)=>
    console.log 'onPropertyCreated'

module.exports = PropertiesPage
