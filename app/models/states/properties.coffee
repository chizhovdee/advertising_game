_ = require('lodash')
BaseState = require('./base')

class PropertiesState extends BaseState
  defaultState: {}
  stateName: "properties"

  generateId: ->
    super(_.keys(@state))

  find: (id)->
    @state[id]

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

  propertyToJSON: (property)->
    resource = @.extendResource(property)

    if resource.builtAt?
      resource.buildingTimeLeft = @.buildingTimeLeftFor(resource)

    resource

  buildingTimeLeftFor: (property)->
    property.builtAt - Date.now()

  propertyIsBuilding: (property)->
    property.builtAt? && @.buildingTimeLeftFor(property)

  accelerateBuilding: (id)->
    delete @state[id].builtAt

    @state[id].updatedAt = Date.now()

    @.update()

    @.addOperation('update', id, @.propertyToJSON(@state[id]))

  toJSON: ->
    state = {}

    for id, resource of @state
      state[id] = @.propertyToJSON(resource)

    state

module.exports = PropertiesState