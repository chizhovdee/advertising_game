Page = require("../page")
Pagination = require("../../lib").Pagination
modals = require('../modals')
request = require('../../lib/request')

Transport = require('../../game_data').Transport
TransportType = require('../../game_data').TransportType

class ShopPage extends Page
  className: "shop page"
  transportGroups: _.map(TransportType.all(), (t)-> t.key)
  transportAttributes: ['consumption', 'reliability', 'carrying', 'travelSpeed', 'good']

  PER_PAGE = 3

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

    request.bind('item_purchased', @.onItemPurchased)

    @el.on('click', '.list .paginate:not(.disabled)', @.onListPaginateClick)
    @el.on('click', '.switches .switch', @.onSwitchPageClick)

    @el.on('click', '.groups .group:not(.current)', @.onGroupClick)
    @el.on('click', '.item .buy:not(.disabled)', @.onBuyClick)
    @el.on('click', '.confirm_popup .start_purchase:not(.disabled)', @.onStartPurchase)

  unbindEventListeners: ->
    super

    request.unbind('item_purchased', @.onItemPurchased)

    @el.off('click', '.list .paginate:not(.disabled)', @.onListPaginateClick)
    @el.off('click', '.switches .switch', @.onSwitchPageClick)

    @el.off('click', '.groups .group:not(.current)', @.onGroupClick)
    @el.off('click', '.item .buy:not(.disabled)', @.onBuyClick)
    @el.off('click', '.confirm_popup .start_purchase:not(.disabled)', @.onStartPurchase)

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

  onBuyClick: (e)=>
    button = $(e.currentTarget)
    button.addClass('disabled')

    @.displayPopup(button,
      @.renderTemplate("confirm",
        button: {
          data: {'item-id': button.data('item-id')}
          className: 'start_purchase'
          text: I18n.t("transport.buttons.buy")
        }
      )

      position: 'left bottom'
      alterClassName: 'confirm_popup'
    )

  onStartPurchase: (e)=>
    button = $(e.currentTarget)
    itemId = button.parents('.confirm_controls').data('item-id')

    if button.data('type') == 'cancel'
      @el.find("#item_#{ itemId } .buy").removeClass('disabled')

      return

    button.addClass('disabled')

    request.send('buy_item', item_id: itemId)

  onItemPurchased: (response)=>
    console.log 'onItemPurchased', response

  basicPriceRequirement: (transport)->
    {basic_money: [transport.basicPrice, @player.basic_money >= transport.basicPrice]}

module.exports = ShopPage
