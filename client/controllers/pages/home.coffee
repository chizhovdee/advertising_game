Page = require("../page")
AdvertisingPage = require('./advertising')
RoutesPage = require('./routes')
TruckingPage = require('./trucking')

class HomePage extends Page
  className: "home page"

  elements:
    '.tab_content': 'tabContentEl'

  tabs: ['trucking', 'routes', 'contracts']

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
      when 'routes'
        @innerPage = new RoutesPage()
      when 'contracts'
        @innerPage = null

    @innerPage?.show(@el.find('.tab_content'))

module.exports = HomePage
