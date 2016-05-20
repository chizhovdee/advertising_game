InnerPage = require("../inner_page")
modals = require('../modals')
request = require("../../lib/request")
Pagination = require("../../lib").Pagination
Advertising = require('../../game_data').Advertising

class AdvertisingPage extends InnerPage
  className: 'advertising inner_page'

  PER_PAGE = 4

  show: ->
    super

    @loading = true

    @.render()

    request.send('load_advertising')

  render: ->
    if @loading
      @.renderPreloader()
    else
      @html(@.renderTemplate("advertising/index"))

  renderList: ->
    @el.find('.list').html(@.renderTemplate("advertising/list"))

  bindEventListeners: ->
    super

    request.bind('advertising_loaded', @.onDataLoaded)

    @el.on('click', '.new', @.onNewClick)
    @el.on('click', '.list .paginate:not(.disabled)', @.onListPaginateClick)
    @el.on('click', '.switches .switch', @.onSwitchPageClick)

  unbindEventListeners: ->
    super

    request.unbind('advertising_loaded', @.onDataLoaded)

    @el.off('click', '.new', @.onNewClick)
    @el.off('click', '.list .paginate:not(.disabled)', @.onListPaginateClick)
    @el.off('click', '.switches .switch', @.onSwitchPageClick)

  onNewClick: =>
    modals.NewAdvertisingModal.show()

  onDataLoaded: (response)=>
    console.log response

    @loading = false

    console.log @list = response.advertising

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

module.exports = AdvertisingPage