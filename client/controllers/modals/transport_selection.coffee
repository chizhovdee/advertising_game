Modal = require("../modal")
TransportModel = require('../../game_data').TransportModel
request = require('../../lib').request
ctx = require('../../context')
Pagination = require("../../lib").Pagination

class TransportSelectionModal extends Modal
  className: 'transport_selection modal'

  tabTypes: ['own', 'in_route', 'shop']
  transportAttributes: ['reliability', 'carrying', 'travelSpeed']

  PER_PAGE = 3

  show: (@context, @data)->
    @playerState = ctx.get('playerState')

    super

    @materialKey = @data.materialKey
    @resource = @data.resource
    @selectedTransportList = @data.selectedTransportList

    @currentTab = 'own'

    @.defineData()

    @.render()

  render: ->
    @updateContent(
      @.renderTemplate('transport_selection/index')
    )

  renderTabContent: ->
    @el.find('.tab_content').html(@.renderTemplate("transport_selection/#{ @currentTab }"))

  bindEventListeners: ->
    super

    @el.on('click', '.list .paginate:not(.disabled)', @.onListPaginateClick)
    @el.on('click', '.switches .switch', @.onSwitchPageClick)

    @el.on('click', '.tabs .tab:not(.current)', @.onTabClick)

    @el.on('click', '.own .select', @.onOwnSelect)

  unbindEventListeners: ->
    super

    @el.off('click', '.list .paginate:not(.disabled)', @.onListPaginateClick)
    @el.off('click', '.switches .switch', @.onSwitchPageClick)

    @el.off('click', '.tabs .tab:not(.current)', @.onTabClick)

    @el.off('click', '.own .select', @.onOwnSelect)

  defineData: ->
    @currentMaterialCount = @playerState.getMaterialFor(@resource, @materialKey)

    switch @currentTab
      when 'own'
        @list = []



        @listPagination = new Pagination(PER_PAGE)
        @paginatedList = @listPagination.paginate(@list, initialize: true)

        @listPagination.setSwitches(@list)

  onTabClick: (e)=>
    tabEl = $(e.currentTarget)

    @el.find('.tabs .tab').removeClass('current')
    tabEl.addClass('current')

    @currentTab = tabEl.data('type')

    @.defineData()

    @.renderTabContent()

  onListPaginateClick: (e)=>
    @paginatedList = @listPagination.paginate(@list,
      back: $(e.currentTarget).data('type') == 'back'
    )

    @.renderTabContent()

  onSwitchPageClick: (e)=>
    @paginatedList = @listPagination.paginate(@list,
      start_count: ($(e.currentTarget).data('page') - 1) * @listPagination.per_page
    )

    @.renderTabContent()

  onOwnSelect: (e)=>
    $(e.currentTarget).data('transport-id')

    @context.addTransport($(e.currentTarget).data('transport-id'))

    @.close()


module.exports = TransportSelectionModal