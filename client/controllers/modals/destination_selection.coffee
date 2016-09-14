Modal = require("../modal")
RouteType = require('../../game_data').RouteType
TransportModel = require('../../game_data').TransportModel
request = require('../../lib').request
ctx = require('../../context')
Pagination = require("../../lib").Pagination
gameData = require('../../game_data')
FactoryType = gameData.FactoryType

class DestinationSelectionModal extends Modal
  className: 'destination_selection modal'

  PER_PAGE = 3

  show: (@context, @senderPlace, @materialKey)->
    @playerState = ctx.get('playerState')

    super

    @.defineData()

    @.render()

  render: ->
    @updateContent(
      @.renderTemplate('destination_selection/index')
    )

  bindEventListeners: ->
    super


  unbindEventListeners: ->
    super

  defineData: ->
    @factoryTypes = []

    for factory in @playerState.factoryRecords()
      continue if factory.factoryTypeId == @senderPlace.id

      type = FactoryType.find(factory.factoryTypeId)

      continue until type.isContainMaterial(@materialKey)

      maxCount = type.materialLimitBy(@materialKey, factory.level)
      currentCount = @playerState.getMaterialFor(@playerState.getResourceFor(factory), @materialKey)

      continue if currentCount >= maxCount

      @factoryTypes.push([type, currentCount, maxCount])

    console.log @factoryTypes

module.exports = DestinationSelectionModal