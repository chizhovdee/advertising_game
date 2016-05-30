_ = require('lodash')
BaseState = require('./base')

class PropertiesState extends BaseState
  defaultState: {}
  stateName: "properties"

  generateId: ->
    super(_.keys(@state))

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

  propertyToJSON: (ad)->
    resource = _.clone(ad)

    if resource.builtAt?
      resource.buildingTimeLeft = resource.builtAt - Date.now()

    resource

  toJSON: ->
    state = {}

    for id, resource of @state
      state[id] = @.propertyToJSON(resource)

    state

module.exports = PropertiesState