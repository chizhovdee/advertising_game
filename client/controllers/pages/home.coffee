Page = require("../page")
TruckingPage = require('./trucking')

class HomePage extends Page
  className: "home page"

  elements:
    '.tab_content': 'tabContentEl'

  tabs: ['trucking']

  hide: ->
    @innerPage?.hide()

    super

  show: ->
    super

    @currentTab = 'trucking'

    @.render()

    @.showInnerPage()

  render: ->
    @html(@.renderTemplate("home/index"))

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

    @currentTab = tabEl.data('type')

    @.showInnerPage()

  showInnerPage: ->
    @innerPage?.hide()
    @innerPage = null

    console.log @currentTab

    switch @currentTab
      when 'trucking'
        @innerPage = new TruckingPage()

    @innerPage?.show(@el.find('.tab_content'))

module.exports = HomePage
