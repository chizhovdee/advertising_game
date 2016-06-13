_ = require('lodash')
BaseState = require('./base')

class TransportState extends BaseState
  defaultState: {}
  stateName: "transport"

  generateId: ->
    super(_.keys(@state))

  find: (id)->
    @state[id]

  create: (type)->
    newId = @.generateId()
    newResource = {
      typeId: type.id
      createdAt: Date.now()
      updatedAt: Date.now()
      serviceability: 100 # исправность %
    }

    @state[newId] = newResource

    @.addOperation('add', newId, @.transportToJSON(newResource))

    @.update()

  setTruckingFor: (ids, truckingId)->
    for id in ids
      @state[id].truckingId = truckingId
      @state[id].updatedAt = Date.now()

      @.addOperation('update', id, @.transportToJSON(@state[id]))

    @.update()

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