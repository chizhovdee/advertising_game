Page = require("../page")
AdvertisingPage = require('./advertising')

class HomePage extends Page
  className: "home page"

  elements:
    '.tab_content': 'tabContentEl'

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

    switch @currentTab
      when 'trucking'
        1

      when 'routes'
        2
      when 'advertising'
        @innerPage = new AdvertisingPage()

    @innerPage?.show(@el.find('.tab_content'))

module.exports = HomePage
