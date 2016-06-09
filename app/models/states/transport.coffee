_ = require('lodash')
BaseState = require('./base')

class TransportState extends BaseState
  defaultState: {}
  stateName: "transport"

  generateId: ->
    super(_.keys(@state))

  create: (type)->
    newId = @.generateId()
    newResource = {
      typeId: type.id
      createdAt: Date.now()
      updatedAt: Date.now()
      damage: 0 # %
    }

    @state[newId] = newResource

    @.update()

    @.addOperation('add', newId, @.transportToJSON(newResource))

  transportToJSON: (transport)->
    resource = @.extendResource(transport)

    # custom extend here

    resource

  toJSON: ->
    state = {}

    for id, resource of @state
      state[id] = @.transportToJSON(resource)

    state

module.exports = TransportState