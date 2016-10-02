Modal = require("../modal")
RouteType = require('../../game_data').RouteType
TransportModel = require('../../game_data').TransportModel
request = require('../../lib').request
ctx = require('../../context')
Pagination = require("../../lib").Pagination
geometry = require('../../lib').geometry
gameData = require('../../game_data')
FactoryType = gameData.FactoryType
MaterialType = gameData.MaterialType
TownLevel = gameData.TownLevel

class DestinationSelectionModal extends Modal
  className: 'destination_selection modal'

  PER_PAGE = 4

  show: (@context, @data)->
    @playerState = ctx.get('playerState')

    super

    @selectedResource = null

    @materialKey = @data.materialKey
    @resource = @data.resource
    @sendingPlace = @data.sendingPlace

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
    @el.on('click', '.select:not(.disabled)', @.onSelectClick)

  unbindEventListeners: ->
    super

    @el.off('click', '.destination:not(.selected)', @.onDestinationClick)
    @el.off('click', '.select:not(.disabled)', @.onSelectClick)

  defineData: ->
    @list = []

    @currentCount = @playerState.getMaterialFor(@resource, @materialKey)

    # town
    town = @playerState.findPlaceRecord('town')

    if materialData = town.getMaterialDataForTrucking(@materialKey)
      @list.push([town, @playerState.getResourceFor(town), materialData.currentCount, materialData.maxCount])

    # factories
    factories = []

    for factory in @playerState.factoryRecords()
      continue if @resource.type == 'factories' && factory.id == @resource.id

      type = factory.type()

      continue unless type.isContainMaterial(@materialKey)

      maxCount = type.materialLimitBy(@materialKey, factory.level)
      factoryResource = @playerState.getResourceFor(factory)
      currentCount = @playerState.getMaterialFor(factoryResource, @materialKey)

      factories.push([factory, factoryResource, currentCount, maxCount])

    # pagination
    @list = @list.concat(factories)
    @listPagination = new Pagination(PER_PAGE)
    @paginatedList = @listPagination.paginate(@list, initialize: true)

    @listPagination.setSwitches(@list)

  onDestinationClick: (e)=>
    el = $(e.currentTarget)

    @el.find('.destination').removeClass('selected')

    el.addClass('selected')

    @selectedResource = el.data('resource')

    @el.find('button.select').removeClass('disabled')

  onSelectClick: (e)=>
    $(e.currentTarget).addClass('disabled')

    @context.applyDestination(@selectedResource)

    @.close()

module.exports = DestinationSelectionModal