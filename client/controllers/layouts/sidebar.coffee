BaseController = require("../base_controller")
request = require("../../lib/request")
pages = require('../pages')
modals = require('../modals')
ctx = require('../../context')

class SidebarLayout extends BaseController
  elements:
    '.vip_money': 'vipMoneyEl'
    '.experience': 'experienceEl'
    '.level': 'levelEl'

  show: ->
    @playerState = ctx.get('playerState')

    super

    @.render()

  render: ->
    @html(@.renderTemplate("sidebar"))

  bindEventListeners: ->
    super

    @player.bind("update", @.onPlayerUpdate)
    @playerState.bind("update", @.onPlayerStateUpdate)

    @el.on("click", ".menu.town", -> pages.TownPage.show())
    @el.on("click", ".menu.trucking", -> pages.TruckingPage.show())
    @el.on('click', '.menu.properties', -> pages.PropertiesPage.show())
    @el.on('click', '.menu.factories', -> pages.FactoriesPage.show())
    @el.on("click", ".menu.transport", -> pages.TransportPage.show())
    @el.on("click", ".menu.shop", -> pages.ShopPage.show())
    @el.on("click", ".menu.advertising", -> pages.AdvertisingPage.show())
    @el.on("click", ".menu.routes", -> pages.RoutesPage.show())

    @el.on('click', '.experience', @.onExprerienceClick)

  onPlayerUpdate: (player)=>
    changes = player.changes()

    @vipMoneyEl.find('.value').text(@player.vip_money) if changes.vip_money

    @experienceEl.find('.value').text(@player.experience) if changes.experience

    if changes.level_progress_percentage
      @experienceEl.find(".percentage").css(width: "#{ @player.level_progress_percentage }%")

    @levelEl.find('.value').text(@player.level) if changes.level

  onPlayerStateUpdate: (playerState)=>
    changes = playerState.changes()

    # TODO

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

module.exports = SidebarLayout