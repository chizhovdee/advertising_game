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
    }

    @state[newId] = newResource

    @.update()

    @.addOperation('add', newId, @.propertyToJSON(newResource))

  propertyToJSON: (ad)->
    resource = _.clone(ad)

    # extend

    resource


  toJSON: ->
    state = {}

    for id, resource of @state
      state[id] = @.propertyToJSON(resource)

    state

module.exports = PropertiesState