Page = require("../page")
Pagination = require("../../lib").Pagination
modals = require('../modals')
request = require('../../lib/request')
RouteType = require('../../game_data').RouteType
Route = require('../../game_data').Route

class RoutesPage extends Page
  className: "routes page"

  PER_PAGE = 3

  show: ->
    super

    @loading = true

    @.render()

    request.send('load_routes')

  render: ->
    if @loading
      @.renderPreloader()
    else
      @html(@.renderTemplate("routes/index"))

  bindEventListeners: ->
    super

    request.bind('routes_loaded', @.onDataLoaded)

    @el.on('click', '.type', @.onTypeClick)
    @el.on('click', 'button.start', @.onStartClick)

  unbindEventListeners: ->
    super

    request.unbind('routes_loaded', @.onDataLoaded)

    @el.off('click', '.type', @.onTypeClick)
    @el.off('click', 'button.start', @.onStartClick)

  onDataLoaded: (response)=>
    console.log response

    @loading = false

    @types = RouteType.all()

    @.render()

  onTypeClick: (e)=>
    @currentTypeKey = $(e.currentTarget).data('type-key')

    @routes = Route.findAllByAttribute('typeKey', @currentTypeKey)

    @list = []
    @listPagination = new Pagination(PER_PAGE)
    @paginatedList = @listPagination.paginate(@routes, initialize: true)

    @listPagination.setSwitches(@routes)

    @.render()

  onStartClick: (e)->
    modals.StartRouteModal.show($(e.currentTarget).data('route-key'))


module.exports = RoutesPage
