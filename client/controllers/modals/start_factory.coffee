Modal = require("../modal")
request = require("../../lib/request")
balance = require('../../lib/balance')
ctx = require('../../context')
FactoryType = require('../../game_data').FactoryType

class StartFactoryModal extends Modal
  className: 'start_factory modal'

  show: (factoryId)->
    super

    @playerState = ctx.get('playerState')

    console.log @factory = _.find(@playerState.factoryRecords(), (p)-> p.id == factoryId)
    console.log @factoryType = FactoryType.find(@factory.factoryTypeId)

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