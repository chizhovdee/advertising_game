Page = require("../page")
Pagination = require("../../lib").Pagination
modals = require('../modals')
request = require('../../lib/request')
balance = require('../../lib/balance')

Transport = require('../../game_data').Transport
TransportType = require('../../game_data').TransportType

class ShopPage extends Page
  className: "shop page"
  transportGroups: _.map(TransportType.all(), (t)-> t.key)
  transportAttributes: ['consumption', 'reliability', 'carrying', 'travelSpeed', 'good']

  TRANSPORT_ITEMS_PER_PAGE = 3
  FUEL_ITEMS_PER_PAGE = 4

  show: ->
    super

    @groups = @transportGroups.concat(['fuel'])

    @fuelTypes = @transportGroups # тип топлива соответствует типу транспорта

    @currentGroup = 'auto'

    @fuelData = {}

    @.defineData()

    @.render()

  render: ->
    @html(@.renderTemplate("shop/index"))

  renderList: ->
    listEl = @el.find('.list')
    listEl.html(@.renderTemplate("shop/list"))
    listEl.removeClass('fuel_list')
    listEl.addClass('fuel_list') if @currentGroup == 'fuel'

  renderFuelItem: (item)->
    @el.find("#item_#{ item }").replaceWith(@.renderTemplate("shop/fuel_item", item: item))

  bindEventListeners: ->
    super

    request.bind('item_purchased', @.onItemPurchased)

    @el.on('click', '.list .paginate:not(.disabled)', @.onListPaginateClick)
    @el.on('click', '.switches .switch', @.onSwitchPageClick)

    @el.on('click', '.groups .group:not(.current)', @.onGroupClick)
    @el.on('click', '.sub_types .type:not(.current)', @.onSubTypeClick)
    @el.on('click', '.item .buy:not(.disabled)', @.onBuyClick)
    @el.on('click', '.confirm_popup .start_purchase:not(.disabled)', @.onStartPurchase)
    @el.on('click', '.item.transport .more_goods', @.onMoreGoodsClick)
    @el.on('click', '.selector .control', @.onSelectorControlClick)
    @el.on('change', '.selector .fuel_value', @.onFuelValueChange)
    @el.on('click', '.item.fuel .controls:not(.disabled) .fill:not(.disabled)', @.onFillClick)

  unbindEventListeners: ->
    super

    request.unbind('item_purchased', @.onItemPurchased)

    @el.off('click', '.list .paginate:not(.disabled)', @.onListPaginateClick)
    @el.off('click', '.switches .switch', @.onSwitchPageClick)

    @el.off('click', '.groups .group:not(.current)', @.onGroupClick)
    @el.off('click', '.sub_types .type:not(.current)', @.onSubTypeClick)
    @el.off('click', '.item .buy:not(.disabled)', @.onBuyClick)
    @el.off('click', '.confirm_popup .start_purchase:not(.disabled)', @.onStartPurchase)
    @el.off('click', '.item.transport .more_goods', @.onMoreGoodsClick)
    @el.off('click', '.selector .control', @.onSelectorControlClick)
    @el.off('change', '.selector .fuel_value', @.onFuelValueChange)
    @el.off('click', '.item.fuel .controls:not(.disabled) .fill:not(.disabled)', @.onFillClick)

  defineData: ->
    if @currentGroup == 'fuel'
      @fuelData = {}
      @list = _.clone(@fuelTypes)

    else
      @subTypes = TransportType.find(@currentGroup).subTypes

      @currentSubType ?= @subTypes[0]

      @list = Transport.select((t)=>
        t.typeKey == @currentGroup && (!@currentSubType? || t.subType == @currentSubType)
      )

    per_page = if @currentGroup == 'fuel' then FUEL_ITEMS_PER_PAGE else TRANSPORT_ITEMS_PER_PAGE

    @listPagination = new Pagination(per_page)
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

    @currentSubType = null
    @subTypes = []

    @.defineData()

    @.renderList()

  onSubTypeClick: (e)=>
    el = $(e.currentTarget)

    @currentSubType = el.data('type')

    @.defineData()

    @.renderList()

  onBuyClick: (e)=>
    button = $(e.currentTarget)
    button.addClass('disabled')

    @.displayConfirm(button,
      button:
        data: {'item-id': button.data('item-id')}
        className: 'start_purchase'
        text: I18n.t("transport.buttons.buy")
    )

  onStartPurchase: (e)=>
    button = $(e.currentTarget)
    itemId = button.parents('.confirm_controls').data('item-id')

    if button.data('type') == 'cancel'
      @el.find("#item_#{ itemId } .buy").removeClass('disabled')

      return

    button.addClass('disabled')

    request.send('buy_item', item_id: itemId, item_type: 'transport')

  onItemPurchased: (response)=>
    console.log 'onItemPurchased', response

    @.displaySuccess("Вы успешно купили транспорт!")

  onMoreGoodsClick: (e)=>
    button = $(e.currentTarget)
    transport = Transport.find(button.data('transport-id'))

    @.displayPopup(button
      @.renderTemplate("transport/goods_popup", transport: transport)
      position: 'top center'
      autoHideDelay: _(10).seconds()
      autoHide: true
    )

  onSelectorControlClick: (e)=>
    button = $(e.currentTarget)

    fuel = button.data('fuel')

    @fuelData[fuel] ?= 0

    switch button.data('type')
      when 'plus'
        @fuelData[fuel] += 1

      when 'minus'
        @fuelData[fuel] -= 1
        delete @fuelData[fuel] if @fuelData[fuel] <= 0

    @.renderFuelItem(fuel)

  onFuelValueChange: (e)=>
    fieldEl = $(e.currentTarget)

    fuel = fieldEl.data('fuel')

    @fuelData[fuel] ?= 0

    value = Math.floor(_.toInteger(fieldEl.val()))

    if _.isNaN(value)
      delete @fuelData[fuel]

    else
      @fuelData[fuel] = value

    delete @fuelData[fuel] if @fuelData[fuel] <= 0

    @.renderFuelItem(fuel)

  onFillClick: (e)=>
    button = $(e.currentTarget)
    fuel = button.data('fuel')
    return if !@fuelData[fuel]? || @fuelData[fuel] <= 0

    request.send('buy_item', item_id: fuel, item_type: 'fuel', amount: @fuelData[fuel])

  basicPriceRequirement: (transport)->
    {basic_money: [transport.basicPrice, @player.basic_money >= transport.basicPrice]}

  fuelPrice: (fuel, value)->
    if value?
      price = balance.fuelBasicPrice(fuel) * value

      {basic_money: [price, @player.basic_money >= price]}

    else
      {basic_money: [balance.fuelBasicPrice(fuel), true]}

module.exports = ShopPage
