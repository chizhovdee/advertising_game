Modal = require("../modal")
request = require("../../lib/request")
balance = require('../../lib/balance')

class BuyFuelModal extends Modal
  className: 'buy_fuel modal'

  show: ->
    super

    @fuel = 0

    @.render()

  render: ->
    @updateContent(
      @.renderTemplate('shop/buy_fuel')
    )

  bindEventListeners: ->
    super

    request.bind('fuel_purchased', @.onFuelPurchased)

    @el.on('click', '.selector:not(.disabled) .control', @.onSelectorControlClick)
    @el.on('change', '.selector:not(.disabled) .fuel_value', @.onFuelValueChange)
    @el.on('click', '.fill:not(.disabled)', @.onFillClick)
    @el.on('click', '.start_fill:not(.disabled)', @.onStartFillClick)

  unbindEventListeners: ->
    super

    request.unbind('fuel_purchased', @.onFuelPurchased)

    @el.off('click', '.selector:not(.disabled) .control', @.onSelectorControlClick)
    @el.off('change', '.selector:not(.disabled) .fuel_value', @.onFuelValueChange)
    @el.off('click', '.fill:not(.disabled)', @.onFillClick)
    @el.off('click', '.start_fill:not(.disabled)', @.onStartFillClick)

  onSelectorControlClick: (e)=>
    button = $(e.currentTarget)

    switch button.data('type')
      when 'plus'
        @fuel += 1

      when 'minus'
        @fuel -= 1
        @fuel = 0 if @fuel <= 0

    @.render()

  onFuelValueChange: (e)=>
    fieldEl = $(e.currentTarget)

    value = Math.floor(_.toInteger(fieldEl.val()))

    if _.isNaN(value)
      @fuel = 0

    else
      @fuel = value

    @fuel = 0 if @fuel <= 0

    @.render()

  onFillClick: (e)=>
    button = $(e.currentTarget)

    @.displayConfirm(button,
      button:
        className: 'start_fill'
        text: I18n.t("shop.buy_fuel.fill")
      position: 'right bottom'
    )

  onStartFillClick: (e)=>
    button = $(e.currentTarget)
    return if button.data('type') == 'cancel'

    button.addClass('disabled')

    @el.find(".selector").addClass('disabled')
    @el.find(".controls .fill").addClass('disabled')

    return if @fuel <= 0

    amount = @fuel
    @fuel = 0

    request.send('buy_fuel', amount: amount)

  fuelPrice: (value)->
    if value?
      price = balance.fuelBasicPrice() * value

      {basic_money: [price, @player.basic_money >= price]}

    else
      {basic_money: [balance.fuelBasicPrice(), true]}

  onFuelPurchased: (response)=>
    if response.is_error
      @.render()

      @.displayResult(
        @el.find('.fill')
        response
        position: "right bottom"
      )
    else
      @.displayResult(null, response)

      @.close()


module.exports = BuyFuelModal