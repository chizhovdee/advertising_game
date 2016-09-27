Page = require("../page")
Pagination = require("../../lib").Pagination
modals = require('../modals')
request = require('../../lib/request')
balance = require('../../lib/balance')

TransportModel = require('../../game_data').TransportModel
TransportGroup = require('../../game_data').TransportGroup

class ShopPage extends Page
  className: "shop page"
  transportAttributes: ['reliability', 'carrying', 'travelSpeed', 'materials']

  PER_PAGE = 3

  show: (options = {})->
    super

    @groupKeys = _.map(TransportGroup.all(), (t)-> t.key)

    @currentGroupKey = options.transportGroupKey || 'truck'

    @.defineData()

    @.render()

  render: ->
    @html(@.renderTemplate("shop/index"))

  renderList: ->
    @el.find('.list').html(@.renderTemplate("shop/list"))

  renderTransportModel: (transportModel)->
    @el.find("#transport_model_#{ transportModel.id }").replaceWith(
      @.renderTemplate("shop/transport_model", transportModel: transportModel)
    )

  bindEventListeners: ->
    super

    request.bind('transport_purchased', @.onTransportPurchased)

    @el.on('click', '.list .paginate:not(.disabled)', @.onListPaginateClick)
    @el.on('click', '.switches .switch', @.onSwitchPageClick)
    @el.on('click', '.groups .group:not(.current)', @.onGroupClick)
    @el.on('click', '.item .buy:not(.disabled)', @.onBuyClick)
    @el.on('click', '.confirm_popup .start_purchase:not(.disabled)', @.onStartPurchase)

  unbindEventListeners: ->
    super

    request.unbind('transport_purchased', @.onTransportPurchased)

    @el.off('click', '.list .paginate:not(.disabled)', @.onListPaginateClick)
    @el.off('click', '.switches .switch', @.onSwitchPageClick)
    @el.off('click', '.groups .group:not(.current)', @.onGroupClick)
    @el.off('click', '.item .buy:not(.disabled)', @.onBuyClick)
    @el.off('click', '.confirm_popup .start_purchase:not(.disabled)', @.onStartPurchase)

  defineData: ->
    @transportGroup = TransportGroup.find(@currentGroupKey)

    @list = TransportModel.select((t)=> t.transportGroupKey == @currentGroupKey)

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

  onBuyClick: (e)=>
    button = $(e.currentTarget)

    @.displayConfirm(button,
      button:
        data: {'item-id': button.data('item-id')}
        className: 'start_purchase'
        text: I18n.t("transport.buttons.buy")
    )

  onStartPurchase: (e)=>
    button = $(e.currentTarget)

    return if button.data('type') == 'cancel'

    itemId = button.parents('.confirm_controls').data('item-id')

    @el.find("#item_#{ itemId } .buy").addClass('disabled')

    button.addClass('disabled')

    request.send('buy_transport', transport_model_id: itemId)

  onTransportPurchased: (response)=>
    @.renderTransportModel(TransportModel.find(response.data.transport_model_id))

    @.displayResult(
      $("#transport_model_#{ response.data.transport_model_id } .result_anchor")
      response
      position: "top center"
    )

  basicPriceRequirement: (transportModel)->
    {basic_money: [transportModel.basicPrice, @player.basic_money >= transportModel.basicPrice]}

module.exports = ShopPage
