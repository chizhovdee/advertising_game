Page = require("../page")
Pagination = require("../../lib").Pagination
modals = require('../modals')
request = require('../../lib/request')
ctx = require('../../context')

TransportModel = require('../../game_data').TransportModel
TransportGroup = require('../../game_data').TransportGroup

class TransportPage extends Page
  className: "transport page"

  PER_PAGE = 3

  show: ->
    @playerState = ctx.get('playerState')

    super

    @groupKeys = _.map(TransportGroup.all(), (t)-> t.key)

    @currentGroupKey = 'truck'

    @.defineData()

    @.render()

  render: ->
    @html(@.renderTemplate("transport/index"))

  renderList: ->
    @el.find('.list').html(@.renderTemplate("transport/list"))

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
    @list = []

    for id, record of @playerState.transport
      transportModel = TransportModel.find(record.transportModelId)

      continue unless transportModel.transportGroupKey == @currentGroupKey

      @list.push(_.assignIn({
        model: transportModel
      }, record))

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

    @currentGroupKey = groupEl.data('group-key')

    @.defineData()

    @.renderList()


module.exports = TransportPage
