Page = require("../page")
Pagination = require("../../lib").Pagination
modals = require('../modals')
request = require('../../lib/request')

Transport = require('../../game_data').Transport
TransportType = require('../../game_data').TransportType

class ShopPage extends Page
  className: "shop page"

  transportGroups: _.map(TransportType.all(), (t)-> t.key)

  PER_PAGE = 2

  show: ->
    super

    @groups = @transportGroups

    @currentGroup = 'auto'

    @.defineData()

    @.render()

  render: ->
    @html(@.renderTemplate("shop/index"))

  renderList: ->
    @el.find('.list').html(@.renderTemplate("shop/list"))

  bindEventListeners: ->
    super

    @el.on('click', '.list .paginate:not(.disabled)', @.onListPaginateClick)
    @el.on('click', '.switches .switch', @.onSwitchPageClick)

    @el.on('click', '.groups .group:not(.current)', @.onGroupClick)

  unbindEventListeners: ->
    super

    @el.off('click', '.list .paginate:not(.disabled)', @.onListPaginateClick)
    @el.off('click', '.switches .switch', @.onSwitchPageClick)

    @el.off('click', '.groups .group:not(.current)', @.onGroupClick)

  defineData: ->
    if @currentGroup in @transportGroups
      @list = Transport.findAllByAttribute('typeKey', @currentGroup)

    @listPagination = new Pagination(PER_PAGE)
    @paginatedList = @listPagination.paginate(@list, initialize: true)

    @listPagination.setSwitches(@list)

  # events
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

  onGroupClick: (e)=>
    groupEl = $(e.currentTarget)

    @el.find('.groups .group').removeClass('current')
    groupEl.addClass('current')

    @currentGroup = groupEl.data('group')

    @.defineData()

    @.renderList()

module.exports = ShopPage
