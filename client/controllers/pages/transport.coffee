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

  renderList: ->
    @el.find('.list').html(@.renderTemplate("transport/list"))

  bindEventListeners: ->
    super

    request.bind('transport_loaded', @.onDataLoaded)

    @el.on('click', '.type', @.onTypeClick)
    @el.on('click', '.list .paginate:not(.disabled)', @.onListPaginateClick)
    @el.on('click', '.switches .switch', @.onSwitchPageClick)

  unbindEventListeners: ->
    super

    request.unbind('transport_loaded', @.onDataLoaded)

    @el.off('click', '.type', @.onTypeClick)
    @el.off('click', '.list .paginate:not(.disabled)', @.onListPaginateClick)
    @el.off('click', '.switches .switch', @.onSwitchPageClick)

  onDataLoaded: (response)=>
    console.log response

    @loading = false

    @types = TransportType.all()

    @.render()

  onTypeClick: (e)=>
    @currentTypeKey = $(e.currentTarget).data('type-key')

    @list = Transport.findAllByAttribute('typeKey', @currentTypeKey)
    @listPagination = new Pagination(PER_PAGE)
    @paginatedList = @listPagination.paginate(@list, initialize: true)

    @listPagination.setSwitches(@list)

    @.render()

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

module.exports = TransportPage
