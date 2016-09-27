Page = require("../page")
modals = require('../modals')
request = require('../../lib/request')
balance = require('../../lib/balance')

class TownPage extends Page
  className: "town page"

  show: ->
    super

    console.log @player

    @.defineData()

    @.render()

  render: ->
    @html(@.renderTemplate("town/index"))

  bindEventListeners: ->
    super

  unbindEventListeners: ->
    super

  defineData: ->

module.exports = TownPage
