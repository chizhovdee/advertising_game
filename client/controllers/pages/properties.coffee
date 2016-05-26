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

    @.defineData()

    @.render()

  render: ->
    @html(@.renderTemplate("properties/index"))

  renderList: ->
    @el.find('.list').html(@.renderTemplate("properties/list"))

  bindEventListeners: ->
    super

    @el.on('click', '.list .paginate:not(.disabled)', @.onListPaginateClick)
    @el.on('click', '.switches .switch', @.onSwitchPageClick)

    @el.on('click', '.property .build', @.onBuildClick)
    @el.on('click', '.property .start_build', @.onStartBuildClick)

    @playerState.bind('update', @.onStateUpdated)

  unbindEventListeners: ->
    super

    @el.off('click', '.list .paginate:not(.disabled)', @.onListPaginateClick)
    @el.off('click', '.switches .switch', @.onSwitchPageClick)

    @el.off('click', '.property .build', @.onBuildClick)
    @el.off('click', '.property .start_build', @.onStartBuildClick)

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

  onSwitchPageClick: (e)=>
    @paginatedList = @listPagination.paginate(@list,
      start_count: ($(e.currentTarget).data('page') - 1) * @listPagination.per_page
    )

    @.renderList()

  onBuildClick: (e)=>
    button = $(e.currentTarget)
    console.log property = _.find(@list, (t)-> t.id == button.data('type-id'))

    @.displayPopup($(e.currentTarget)
      @.renderTemplate("properties/build_popup", property: property)
      position: 'left bottom'
      alterClassName: 'property_build_popup'
    )

  onStartBuildClick: (e)->
    console.log 'onStartBuildClick'

  buildPriceRequirement: (type)->
    {basic_money: [type.basicPrice, @player.basic_money >= type.basicPrice]}



module.exports = PropertiesPage
