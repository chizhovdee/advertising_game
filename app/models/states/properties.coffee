_ = require('lodash')
BaseState = require('./base')

PropertyType = require('../../game_data').PropertyType

class PropertiesState extends BaseState
  defaultState: {}
  stateName: "properties"

  generateId: ->
    super(_.keys(@state))

  find: (id)->
    @state[id]

  findByTypeId: (typeId)->
    for id, resource of @state
      return resource if resource.typeId == typeId

  create: (type)->
    newId = @.generateId()
    newResource = {
      typeId: type.id
      level: 1
      createdAt: Date.now()
      updatedAt: Date.now()
      builtAt: Date.now() + type.buildDuration
    }

    @state[newId] = newResource

    @.update()

    @.addOperation('add', newId, @.propertyToJSON(newResource))

  accelerateBuilding: (id)->
    delete @state[id].builtAt
    delete @state[id].upgradeAt

    @state[id].updatedAt = Date.now()

    @.update()

    @.addOperation('update', id, @.propertyToJSON(@state[id]))

  upgrade: (id)->
    property = @state[id]
    type = PropertyType.find(property.typeId)

    delete @state[id].builtAt # удаление лишнего поля

    @state[id].upgradeAt = Date.now() + type.upgradeDurationBy(property.level)
    # after
    @state[id].level += 1
    @state[id].updatedAt = Date.now()

    @.update()

    @.addOperation('update', id, @.propertyToJSON(@state[id]))

  rentOut: (id)->
    @state[id].rentFinishdAt = Date.now() + PropertyType.rentOutDuration
    # after
    @state[id].updatedAt = Date.now()

    @.update()

    @.addOperation('update', id, @.propertyToJSON(@state[id]))

  buildingTimeLeftFor: (property)->
    property.builtAt - Date.now()

  propertyIsBuilding: (property)->
    property.builtAt? && property.builtAt > Date.now()

  upgradingTimeLeftFor: (property)->
    property.upgradeAt - Date.now()

  propertyIsUpgrading: (property)->
    property.upgradeAt? && property.upgradeAt > Date.now()

  rentTimeLeftFor: (property)->
    property.rentFinishdAt - Date.now()

  propertyIsRented: (property)->
    # достаточно наличие поля
    property.rentFinishdAt?

  propertyToJSON: (property)->
    resource = @.extendResource(property)

    if @.propertyIsBuilding(resource)
      resource.buildingTimeLeft = @.buildingTimeLeftFor(resource)

    else if @.propertyIsUpgrading(resource)
      resource.upgradingTimeLeft = @.upgradingTimeLeftFor(resource)

    else if @.propertyIsRented(resource)
      resource.rentTimeLeft = @.rentTimeLeftFor(resource)

    resource

  toJSON: ->
    state = {}

    for id, resource of @state
      state[id] = @.propertyToJSON(resource)

    state

module.exports = PropertiesState