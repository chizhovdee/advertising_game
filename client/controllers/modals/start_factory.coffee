Modal = require("../modal")
request = require("../../lib/request")
balance = require('../../lib/balance')

class StartFactoryModal extends Modal
  className: 'start_factory modal'

  show: (factoryId)->
    super

    console.log factoryId

    @.render()

  render: ->
    @updateContent(
      @.renderTemplate('factories/start')
    )

  bindEventListeners: ->
    super

  unbindEventListeners: ->
    super


module.exports = StartFactoryModal