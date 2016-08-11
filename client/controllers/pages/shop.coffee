Page = require("../page")
Pagination = require("../../lib").Pagination
modals = require('../modals')
request = require('../../lib/request')
balance = require('../../lib/balance')

TransportModel = require('../../game_data').TransportModel
TransportGroup = require('../../game_data').TransportGroup

class ShopPage extends Page
  className: "shop page"
  transportAttributes: ['consumption', 'reliability', 'carrying', 'travelSpeed', 'good']

  PER_PAGE = 4

  show: (options = {})->
    super

    @groups = _.map(TransportGroup.all(), (t)-> t.key)

    @currentGroupKey = options.transportGroupKey || 'truck'

    @.defineData()

    @.render()

  render: ->
    @html(@.renderTemplate("shop/index"))

  renderList: ->
    listEl = @el.find('.list')
    listEl.html(@.renderTemplate("shop/list"))

  renderTransportItem: (transport)->
    @el.find("#item_#{ transport.id }").replaceWith(
      @.renderTemplate("shop/transport_item", transport: transport)
    )

  bindEventListeners: ->
    super

    request.bind('item_purchased', @.onItemPurchased)

    @el.on('click', '.list .paginate:not(.disabled)', @.onListPaginateClick)
    @el.on('click', '.switches .switch', @.onSwitchPageClick)

    @el.on('click', '.groups .group:not(.current)', @.onGroupClick)
    @el.on('click', '.sub_types .type:not(.current)', @.onSubTypeClick)
    @el.on('click', '.item .buy:not(.disabled)', @.onBuyClick)
    @el.on('click', '.confirm_popup .start_purchase:not(.disabled)', @.onStartPurchase)



  unbindEventListeners: ->
    super


  defineData: ->
    @transportGroup = TransportGroup.find(@currentGroupKey)

    @list = TransportModel.select((t)=>t.transportGroupKey == @currentGroup)

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

    request.send('buy_item', item_id: itemId, item_type: 'transport')

  onItemPurchased: (response)=>
    @.handleResponse(response)

  basicPriceRequirement: (transport)->
    {basic_money: [transport.basicPrice, @player.basic_money >= transport.basicPrice]}

  handleResponse: (response)->
    @.renderTransportItem(TransportModel.find(response.data.item_id))

    @.displayResult(
      $("#item_#{ response.data.item_id } .result_anchor") if response.data?.item_id?
      response
      position: "top center"
    )

module.exports = ShopPage
