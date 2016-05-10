Page = require("../page")
Pagination = require("../../lib").Pagination
modals = require('../modals')
request = require('../../lib/request')
RoutesPage = require('./routes')

Route = require('../../game_data').Route
Transport = require('../../game_data').Transport

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

    console.log @list = _.sortBy((
      for id, data of response.trucking
        _.assignIn({
          id: id
          route: Route.find(data.routeId)
          transport: Transport.find(data.transportId)
        }, data)
    ), (trucking)-> trucking.leftTime)

    @listPagination = new Pagination(PER_PAGE)
    @paginatedList = @listPagination.paginate(@list, initialize: true)

    @listPagination.setSwitches(@list)

    @.render()

  onRoutesButtonClick: ->
    RoutesPage.show()

module.exports = TruckingPage
