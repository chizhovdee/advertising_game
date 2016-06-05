InnerPage = require("../inner_page")
Pagination = require("../../lib").Pagination
modals = require('../modals')
request = require('../../lib/request')
VisualTimer = require("../../lib").VisualTimer
ctx = require('../../context')
Route = require('../../game_data').Route

class RoutesPage extends InnerPage
  className: "routes inner_page"

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
    @html(@.renderTemplate("routes/index"))

    @.setupTimers()

  renderList: ->
    @el.find('.list').html(@.renderTemplate("routes/list"))

    @.setupTimers()

  setupTimers: ->
    timeDiff = Date.now() - @playerState.routesUpdatedAt

    for resource in @paginatedList
      if resource.expireTimeLeft > 0
        @timers[resource.id] ?= new VisualTimer()
        @timers[resource.id].setElement($("#route_#{ resource.id } .timer .value"))
        @timers[resource.id].start(resource.expireTimeLeft - timeDiff)

  bindEventListeners: ->
    super

    @el.on('click', 'button.start', @.onStartClick)

  unbindEventListeners: ->
    super

    @el.off('click', 'button.start', @.onStartClick)

  defineData: ->
    console.log @list = _.sortBy((
      for id, resource of @playerState.routes
        _.assignIn({
          id: id
          route: Route.find(resource.routeId)
        }, resource)
    ), (ad)-> ad.createdAt)

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

  onStartClick: (e)->
    modals.StartRouteModal.show($(e.currentTarget).data('route-key'))


module.exports = RoutesPage
