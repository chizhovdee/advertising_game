Page = require("../page")
Pagination = require("../../lib").Pagination
modals = require('../modals')
request = require('../../lib/request')
RoutesPage = require('./routes')

Route = require('../../game_data').Route
Transport = require('../../game_data').Transport
VisualTimer = require('../../lib').VisualTimer

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
    request.bind('trucking_collected', @.onTruckingCollected)

    @el.on('click', '.head_controls button.routes', @.onRoutesButtonClick)
    @el.on('click', '.list button.collect:not(.disabled)', @.onCollectButtonClick)

  unbindEventListeners: ->
    super

    request.unbind('trucking_loaded', @.onDataLoaded)
    request.unbind('trucking_collected', @.onTruckingCollected)

    @el.off('click', '.head_controls button.routes', @.onRoutesButtonClick)
    @el.off('click', '.list button.collect:not(.disabled)', @.onCollectButtonClick)

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

    for trucking in @paginatedList
      continue if trucking.leftTime <= 0

      timer = new VisualTimer(@el.find("#trucking_#{ trucking.id } .timer .value"))
      timer.start(trucking.leftTime)

  onRoutesButtonClick: ->
    RoutesPage.show()

  onCollectButtonClick: (e)->
    button = $(e.currentTarget)
    button.addClass('disabled')

    request.send('collect_trucking', trucking_id: button.data('trucking-id'))

  onTruckingCollected: (response)->
    console.log response


module.exports = TruckingPage
