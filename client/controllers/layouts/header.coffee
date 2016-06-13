BaseController = require("../base_controller")
request = require("../../lib/request")
modals = require('../modals')

class HeaderLayout extends BaseController
  elements:
    '.basic_money': 'basicMoneyEl'
    '.reputation': 'reputationEl'
    '.fuel': 'fuelEl'

  show: ->
    super

    @.render()

  render: ->
    @html(@.renderTemplate("header"))

  bindEventListeners: ->
    super

    @player.bind("update", @.onPlayerUpdate)

  onPlayerUpdate: (player)=>
    # обновляем каждый фрагмент отдельно если нужно

    console.log 'Player changes', changes = player.changes()

    @basicMoneyEl.find('.value').text(@player.basic_money) if changes.basic_money
    @reputationEl.find('.value').text(@player.reputation) if changes.reputation
    @fuelEl.find('.value').text(@player.fuel) if changes.fuel





module.exports = HeaderLayout