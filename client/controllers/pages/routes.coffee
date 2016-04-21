Page = require("../page")
Pagination = require("../../lib").Pagination
modals = require('../modals')
request = require('../../lib/request')

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

  unbindEventListeners: ->
    super

    request.unbind('routes_loaded', @.onDataLoaded)

  onDataLoaded: (response)=>
    console.log response

    @loading = false

    @list = []
    @listPagination = new Pagination(PER_PAGE)
    @paginatedList = @listPagination.paginate(@list, initialize: true)

    @listPagination.setSwitches(@list)

    @.render()


module.exports = RoutesPage
