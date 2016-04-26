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

  unbindEventListeners: ->
    super

    request.unbind('routes_loaded', @.onDataLoaded)

    @el.off('click', '.type', @.onTypeClick)

  onDataLoaded: (response)=>
    console.log response

    @loading = false

    @types = RouteType.all()

#    @list = []
#    @listPagination = new Pagination(PER_PAGE)
#    @paginatedList = @listPagination.paginate(@list, initialize: true)
#
#    @listPagination.setSwitches(@list)

    @.render()

  onTypeClick: (e)=>
    console.log $(e.currentTarget).data('type-key')


module.exports = RoutesPage
