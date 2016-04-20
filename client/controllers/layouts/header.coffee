Layout = require("../layout")
Player = require("../../models").Player
VisualTimer = require("../../lib/visual_timer")
request = require("../../lib/request")
pages = require('../pages')
modals = require('../modals')

class HeaderLayout extends Layout
  elements:
    '.basic_money': 'basicMoneyEl'
    '.vip_money': 'vipMoneyEl'
    '.experience': 'experienceEl'
    '.level': 'levelEl'

  show: ->
    super

    @.render()

  render: ->
    @html(@.renderTemplate("header"))

  bindEventListeners: ->
    super

    @player.bind("update", @.onPlayerUpdate)

    @el.on("click", ".menu.staff", -> pages.StaffPage.show())
    @el.on("click", ".menu.properties", -> pages.PropertiesPage.show())
    @el.on("click", ".menu.trucking", -> pages.TruckingPage.show())

    @el.on('click', '.experience', @.onExprerienceClick)

  onPlayerUpdate: (player)=>
    # обновляем каждый фрагмент отдельно если нужно

    console.log 'Player changes', changes = player.changes()

    @basicMoneyEl.find('.value').text(@player.basic_money) if changes.basic_money

    @vipMoneyEl.find('.value').text(@player.vip_money) if changes.vip_money

    @experienceEl.find('.value').text(@player.experience) if changes.experience

    if changes.level_progress_percentage
      @experienceEl.find(".percentage").css(width: "#{ @player.level_progress_percentage }%")

    @levelEl.find('.value').text(@player.level) if changes.level

  onExprerienceClick: =>
    @player.experience_to_next_level

    @.displayPopup(@experienceEl,
      @.renderTemplate('experience_to_next_level', character: @player),
      position: 'bottom left'
      showDuration: 200
      autoHideDelay: _(3).seconds()
      autoHide: true
    )

#    @experienceEl.notify(
#      {content: I18n.t('common.experience_to_next_level', value: @character.experience_to_next_level)}
#      {
#        elementPosition: 'bottom left'
#        style: "game"
#        className: 'small_info'
#        showDuration: 200
#        autoHideDelay: _(3).seconds()
#      }
#    )


module.exports = HeaderLayout