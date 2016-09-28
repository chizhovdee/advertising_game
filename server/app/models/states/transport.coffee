_ = require('lodash')
BaseState = require('./base')

class TransportState extends BaseState
  defaultState: {}
  stateName: "transport"

  addTransport: (transportModelId)->
    newId = @.generateId()
    newRecord = {
      id: newId
      transportModelId: transportModelId
      createdAt: Date.now()
      updatedAt: Date.now()
      serviceability: 100 # исправность %
    }

    @state[newId] = newRecord

    @.addOperation('add', newId, @.recordToJSON(newRecord))

    @.update()

  setTruckingFor: (ids, truckingId)->
    for id in ids
      @state[id].truckingId = truckingId
      @state[id].updatedAt = Date.now()

      @.addOperation('update', id, @.recordToJSON(@state[id]))

    @.update()


module.exports = TransportState