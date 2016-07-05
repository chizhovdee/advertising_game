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

  propertyIsBuilding: (id)->
    property = @.find(id)

    property.builtAt? && @.buildingTimeLeftFor(property)

  toJSON: ->
    state = {}

    for id, resource of @state
      state[id] = @.propertyToJSON(resource)

    state

module.exports = PropertiesState