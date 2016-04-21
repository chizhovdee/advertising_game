Page = require("../page")
Pagination = require("../../lib").Pagination
modals = require('../modals')
request = require('../../lib/request')

RoutesPage = require('./routes')

class TruckingPage extends Page
  className: "trucking page"

  PER_PAGE = 3

  show: ->
    super

    @loading = true

    @.render()

    request.send('load_trucking')

  render: ->
    if @loading
      @.renderPreloader()
    else
      @html(@.renderTemplate("trucking/index"))

  bindEventListeners: ->
    super

    request.bind('trucking_loaded', @.onDataLoaded)

    @el.on('click', '.head_controls button.routes', @.onRoutesButtonClick)

  unbindEventListeners: ->
    super

    request.unbind('trucking_loaded', @.onDataLoaded)

    @el.off('click', '.head_controls button.routes', @.onRoutesButtonClick)

  onDataLoaded: (response)=>
    console.log response

    @loading = false

    @list = []
    @listPagination = new Pagination(PER_PAGE)
    @paginatedList = @listPagination.paginate(@list, initialize: true)

    @listPagination.setSwitches(@list)

    @.render()

  onRoutesButtonClick: ->
    RoutesPage.show()

module.exports = TruckingPage
