BaseController = require("../base_controller")
Pagination = require("../../lib/index").Pagination
request = require('../../lib/request')

class TransportListLayout extends BaseController
  tabs: ['in_garage', 'in_shop', 'in_route']

  PER_PAGE = 3

  show: ->
    super

    @currentTab = @tabs[0]

    @listPagination = new Pagination(PER_PAGE)

    @.defineData()

    @.render()

  render: ->
    @html(@.renderTemplate("transport_list/index"))

  renderList: ->
    @el.find('.list').html(@.renderTemplate("transport_list/list"))

  bindEventListeners: ->
    super

    @el.on('click', '.tabs .tab:not(.current)', @.onTabClick)

  unbindEventListeners: ->
    super

    @el.off('click', '.tabs .tab:not(.current)', @.onTabClick)

  defineData: ->
    @list = []

    switch @currentTab
      when 'in_garage'
        1

    @paginatedList = @listPagination.paginate(@list, initialize: true)

    @listPagination.setSwitches(@list)

  onTabClick: (e)=>
    tabEl = $(e.currentTarget)

    @el.find('.tabs .tab').removeClass('current')

    tabEl.addClass('current')

    @currentTab = tabEl.data('tab')

    @.defineData()

    @.renderList()

module.exports = TransportListLayout
