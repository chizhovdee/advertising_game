Modal = require("../modal")
TransportModel = require('../../game_data').TransportModel
request = require('../../lib').request
ctx = require('../../context')
Pagination = require("../../lib").Pagination

class TransportSelectionModal extends Modal
  className: 'transport_selection modal'

  transportAttributes: ['carrying', 'travelSpeed', 'serviceability']

  PER_PAGE = 6

  show: (@context, @data)->
    @playerState = ctx.get('playerState')

    super

    @materialKey = @data.materialKey
    @resource = @data.resource
    @selectedTransportList = @data.transportList

    @.defineData()

    @.render()

  render: ->
    @updateContent(
      @.renderTemplate('transport_selection/index')
    )

  renderList: ->
    @el.find('.list').html(
      @.renderTemplate('transport_selection/list')
    )

  bindEventListeners: ->
    super

    @el.on('click', '.list .paginate:not(.disabled)', @.onListPaginateClick)
    @el.on('click', '.switches .switch', @.onSwitchPageClick)
    @el.on('click', '.transport .select', @.onSelectClick)

  unbindEventListeners: ->
    super

    @el.off('click', '.list .paginate:not(.disabled)', @.onListPaginateClick)
    @el.off('click', '.switches .switch', @.onSwitchPageClick)
    @el.off('click', '.transport .select', @.onSelectClick)

  defineData: ->
    @currentMaterialCount = @playerState.getMaterialFor(@resource, @materialKey)

    @list = []

    for transport in @playerState.transportRecords()
      if transport.model().isContainMaterial(@materialKey)
        @list.push transport

    @listPagination = new Pagination(PER_PAGE)
    @paginatedList = @listPagination.paginate(@list, initialize: true)

    @listPagination.setSwitches(@list)

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

  onSelectClick: (e)=>
    @context.applyTransport($(e.currentTarget).data('transport-id'))

    @.close()

module.exports = TransportSelectionModal