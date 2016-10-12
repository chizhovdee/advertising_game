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

    @.addRecord(newId, newRecord)


module.exports = TransportState