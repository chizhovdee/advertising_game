_ = require('lodash')
BaseState = require('./base')

Transport = require('../../game_data').Transport

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
      typeId: type.id # transport id
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

  countByTransportTypeKey: (typeKey)->
    count = 0

    for id, resource of @state
      (count += 1 if Transport.find(resource.typeId)?.typeKey == typeKey)

    count

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