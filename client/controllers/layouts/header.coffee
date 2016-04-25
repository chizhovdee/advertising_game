Layout = require("../layout")
request = require("../../lib/request")
pages = require('../pages')
modals = require('../modals')

class HeaderLayout extends Layout
  elements:
    '.basic_money': 'basicMoneyEl'

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

#    console.log 'Player changes', changes = player.changes()
#
#    @basicMoneyEl.find('.value').text(@player.basic_money) if changes.basic_money
#
#    @vipMoneyEl.find('.value').text(@player.vip_money) if changes.vip_money
#
#    @experienceEl.find('.value').text(@player.experience) if changes.experience
#
#    if changes.level_progress_percentage
#      @experienceEl.find(".percentage").css(width: "#{ @player.level_progress_percentage }%")
#
#    @levelEl.find('.value').text(@player.level) if changes.level




module.exports = HeaderLayout