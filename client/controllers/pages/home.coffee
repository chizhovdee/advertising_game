Page = require("../page")

class HomePage extends Page
  className: "home page"

  elements:
    '.tab_content': 'tabContentEl'

  hide: ->
    super

  show: ->
    super

    @currentType = 'trucking'

    @.render()

  render: ->
    @html(@.renderTemplate("home/index"))

  renderTabContent: ->
    @tabContentEl.html(@.renderTemplate("home/#{ @currentType }") )

  bindEventListeners: ->
    super

    @el.on('click', '.tabs .tab:not(.current)', @.onTabClick)

  unbindEventListeners: ->
    super

    @el.off('click', '.tabs .tab:not(.current)', @.onTabClick)

  onTabClick: (e)=>
    tabEl = $(e.currentTarget)

    @el.find('.tabs .tab').removeClass('current')
    tabEl.addClass('current')

    console.log @currentType = tabEl.data('type')

    @.renderTabContent()

module.exports = HomePage
