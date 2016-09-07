Page = require("../page")
Pagination = require("../../lib").Pagination
modals = require('../modals')
request = require('../../lib/request')
VisualTimer = require("../../lib").VisualTimer
ctx = require('../../context')
RouteGroup = require('../../game_data').RouteGroup
RouteType = require('../../game_data').RouteType

class RoutesPage extends Page
  className: "routes page"

  PER_PAGE = 6

  show: (options = {})->
    super

    @groupKeys = _.map(RouteGroup.all(), (t)-> t.key)

    @currentGroupKey = options.transportGroupKey || 'coal_route_group'

    @.defineData()

    @.render()

  render: ->
    @html(@.renderTemplate("routes/index"))

  renderList: ->
    @el.find('.list').html(@.renderTemplate("routes/list"))

  bindEventListeners: ->
    super

    @el.on('click', '.list .paginate:not(.disabled)', @.onListPaginateClick)
    @el.on('click', '.switches .switch', @.onSwitchPageClick)
    @el.on('click', '.groups .group:not(.current)', @.onGroupClick)
    @el.on('click', '.start', @.onStartClick)

  unbindEventListeners: ->
    super

    @el.off('click', '.list .paginate:not(.disabled)', @.onListPaginateClick)
    @el.off('click', '.switches .switch', @.onSwitchPageClick)
    @el.off('click', '.groups .group:not(.current)', @.onGroupClick)
    @el.off('click', '.start', @.onStartClick)

  defineData: ->
    @routeGroup = RouteGroup.find(@currentGroupKey)

    @list = RouteType.select((t)=> t.routeGroupKey == @currentGroupKey)

    @listPagination = new Pagination(PER_PAGE)
    @paginatedList = @listPagination.paginate(@list, initialize: true)

    @listPagination.setSwitches(@list)

   # events
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

  onGroupClick: (e)=>
    groupEl = $(e.currentTarget)

    @el.find('.groups .group').removeClass('current')
    groupEl.addClass('current')

    @currentGroupKey = groupEl.data('group-key')

    @.defineData()

    @.renderList()

  onStartClick: (e)=>
    modals.StartRouteModal.show($(e.currentTarget).data('route-id'))

module.exports = RoutesPage
