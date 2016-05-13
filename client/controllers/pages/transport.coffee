Page = require("../page")
Pagination = require("../../lib").Pagination
modals = require('../modals')
request = require('../../lib/request')
TransportType = require('../../game_data').TransportType
Transport = require('../../game_data').Transport

class TransportPage extends Page
  className: "transport page"

  PER_PAGE = 3

  show: ->
    super

    @loading = true

    @.render()

    request.send('load_transport')

  render: ->
    if @loading
      @.renderPreloader()
    else
      @html(@.renderTemplate("transport/index"))

  bindEventListeners: ->
    super

    request.bind('transport_loaded', @.onDataLoaded)

    @el.on('click', '.type', @.onTypeClick)

  unbindEventListeners: ->
    super

    request.unbind('transport_loaded', @.onDataLoaded)

    @el.off('click', '.type', @.onTypeClick)

  onDataLoaded: (response)=>
    console.log response

    @loading = false

    @types = TransportType.all()

    @.render()

  onTypeClick: (e)=>
    @currentTypeKey = $(e.currentTarget).data('type-key')

    @routes = Route.findAllByAttribute('typeKey', @currentTypeKey)

    @list = []
    @listPagination = new Pagination(PER_PAGE)
    @paginatedList = @listPagination.paginate(@routes, initialize: true)

    @listPagination.setSwitches(@routes)

    @.render()

module.exports = TransportPage
