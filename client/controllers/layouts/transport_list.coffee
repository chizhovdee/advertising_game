BaseController = require("../base_controller")
Pagination = require("../../lib/index").Pagination
request = require('../../lib/request')
gameData = require('../../game_data')
TransportGroup = gameData.TransportGroup
TransportModel = gameData.TransportModel

class TransportListLayout extends BaseController
  tabs: ['in_garage', 'in_shop', 'in_route']

  PER_PAGE = 3

  show: (options = {})->
    super

    @currentTab = @tabs[0]

    @groupKeys = _.map(TransportGroup.all(), (t)-> t.key)

    @currentGroupKey = options.transportGroupKey || 'truck'

    @listPagination = new Pagination(PER_PAGE)

    @.defineData()

    @.render()

  render: ->
    @html(@.renderTemplate("transport_list/index"))

  renderList: ->
    @el.find('.list').html(@.renderTemplate("transport_list/list"))

  renderGroups: ->
    @el.find('.groups').replaceWith(@.renderTemplate("transport_list/groups"))

  bindEventListeners: ->
    super

    request.bind('transport_purchased', @.onTransportPurchased)

    @el.on('click', '.tabs .tab:not(.current)', @.onTabClick)
    @el.on('click', '.groups .group:not(.current)', @.onGroupClick)
    @el.on('click', '.list .paginate:not(.disabled)', @.onListPaginateClick)
    @el.on('click', '.switches .switch', @.onSwitchPageClick)
    @el.on('click', '.transport_model .buy:not(.disabled)', @.onBuyClick)
    @el.on('click', '.confirm_popup .start_purchase:not(.disabled)', @.onStartPurchase)

  unbindEventListeners: ->
    super

    request.unbind('transport_purchased', @.onTransportPurchased)

    @el.off('click', '.tabs .tab:not(.current)', @.onTabClick)
    @el.off('click', '.groups .group:not(.current)', @.onGroupClick)
    @el.off('click', '.list .paginate:not(.disabled)', @.onListPaginateClick)
    @el.off('click', '.switches .switch', @.onSwitchPageClick)
    @el.off('click', '.transport_model .buy:not(.disabled)', @.onBuyClick)
    @el.off('click', '.confirm_popup .start_purchase:not(.disabled)', @.onStartPurchase)

  defineData: ->
    @list = []

    @transportGroup = TransportGroup.find(@currentGroupKey)

    switch @currentTab
      when 'in_garage'
        for record in @playerState.transportRecords()
          if record.model().transportGroupKey == @currentGroupKey
            @list.push [record.model(), record]

      when 'in_shop'
        TransportModel.each((model)=>
          if model.transportGroupKey == @currentGroupKey
            @list.push [model]
        )


    @paginatedList = @listPagination.paginate(@list, initialize: true)

    @listPagination.setSwitches(@list)

  # events
  onTabClick: (e)=>
    tabEl = $(e.currentTarget)

    @el.find('.tabs .tab').removeClass('current')

    tabEl.addClass('current')

    @currentTab = tabEl.data('tab')

    @currentGroupKey = @groupKeys[0]

    @.defineData()

    @.renderGroups()

    @.renderList()

  onGroupClick: (e)=>
    groupEl = $(e.currentTarget)

    @el.find('.groups .group').removeClass('current')
    groupEl.addClass('current')

    @currentGroupKey = groupEl.data('group-key')

    @.defineData()

    @.renderList()

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

  onBuyClick: (e)=>
    button = $(e.currentTarget)

    @.displayConfirm(button,
      button:
        data: {'model-id': button.data('model-id')}
        className: 'start_purchase'
        text: I18n.t("transport.buttons.buy")
    )

  onStartPurchase: (e)=>
    button = $(e.currentTarget)

    return if button.data('type') == 'cancel'

    modelId = button.parents('.confirm_controls').data('model-id')

    @el.find("#transport_model_#{ modelId } .buy").addClass('disabled')

    button.addClass('disabled')

    request.send('purchase_transport', transport_model_id: modelId)

  onTransportPurchased: (response)=>
    @.displayResult(null, response)

  # utils
  basicPriceRequirement: (transportModel)->
    {basic_money: [transportModel.basicPrice, @player.basic_money >= transportModel.basicPrice]}

module.exports = TransportListLayout
