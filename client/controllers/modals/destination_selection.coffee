Modal = require("../modal")
RouteType = require('../../game_data').RouteType
TransportModel = require('../../game_data').TransportModel
request = require('../../lib').request
ctx = require('../../context')
Pagination = require("../../lib").Pagination
geometry = require('../../lib').geometry
gameData = require('../../game_data')
FactoryType = gameData.FactoryType

class DestinationSelectionModal extends Modal
  className: 'destination_selection modal'

  PER_PAGE = 4

  show: (@context, @data)->
    @playerState = ctx.get('playerState')

    super

    @senderPlace = @data.senderPlace
    @materialKey = @data.materialKey
    @resource = @data.resource

    @geometry = geometry

    @.defineData()

    @.render()

  render: ->
    @updateContent(
      @.renderTemplate('destination_selection/index')
    )

  bindEventListeners: ->
    super

    @el.on('click', '.destination:not(.selected)', @.onDestinationClick)


  unbindEventListeners: ->
    super

    @el.off('click', '.destination:not(.selected)', @.onDestinationClick)

  defineData: ->
    @currentCount = @playerState.getMaterialFor(@resource, @materialKey)

    @factoryTypes = []

    for factory in @playerState.factoryRecords()
      continue if factory.factoryTypeId == @senderPlace.id

      type = FactoryType.find(factory.factoryTypeId)

      continue until type.isContainMaterial(@materialKey)

      maxCount = type.materialLimitBy(@materialKey, factory.level)
      currentCount = @playerState.getMaterialFor(@playerState.getResourceFor(factory), @materialKey)

      continue if currentCount >= maxCount

      @factoryTypes.push([type, currentCount, maxCount])

    @factoryTypes

    # pagination
    @list = @factoryTypes
    @listPagination = new Pagination(PER_PAGE)
    @paginatedList = @listPagination.paginate(@list, initialize: true)

    @listPagination.setSwitches(@list)

  onDestinationClick: (e)=>
    el = $(e.currentTarget)

    @el.find('.destination').removeClass('selected')

    el.addClass('selected')



module.exports = DestinationSelectionModal