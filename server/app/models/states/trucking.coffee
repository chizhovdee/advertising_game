_ = require('lodash')
BaseState = require('./base')

class TruckingState extends BaseState
  defaultState: {}
  stateName: "trucking"

  createTrucking: (transportId, duration)->
    newId = @.generateId()
    newRecord = {
      id: newId
      transportId: transportId
      completeAt: Date.now() + duration
      createdAt: Date.now()
      updatedAt: Date.now()
    }

    @.addRecord(newId, newRecord)

  recordToJSON: (record)->
    record = super(record)

    record.completeIn = record.completeAt - Date.now()

    record

  toJSON: ->
    state = {}

    for id, record of @state
      state[id] = @.recordToJSON(record)

    state

module.exports = TruckingState