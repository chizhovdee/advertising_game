Page = require("../page")
Pagination = require("../../lib").Pagination
modals = require('../modals')
request = require('../../lib/request')
ctx = require('../../context')

class TransportPage extends Page
  className: "transport page"
  tabs: ['in_garage', 'in_shop', 'in_route']

  show: ->
    super

    @currentTab = @tabs[0]

    @.defineData()

    @.render()

  render: ->
    @html(@.renderTemplate("transport/index"))


  bindEventListeners: ->
    super

    @el.on('click', '.tabs .tab:not(.current)', @.onTabClick)

  unbindEventListeners: ->
    super

    @el.off('click', '.tabs .tab:not(.current)', @.onTabClick)

  defineData: ->
    switch @currentTab
      when 'in_garage'
        1

  onTabClick: (e)=>
    tabEl = $(e.currentTarget)

    @el.find('.tabs .tab').removeClass('current')

    tabEl.addClass('current')

    @currentTab = tabEl.data('tab')

    @.defineData()

module.exports = TransportPage
