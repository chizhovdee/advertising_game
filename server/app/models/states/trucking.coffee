_ = require('lodash')
BaseState = require('./base')

class TruckingState extends BaseState
  defaultState: {}
  stateName: "trucking"

  createTrucking: (data, duration)->
    newId = @.generateId()
    newRecord = {
      id: newId
      transportId: data.transportId
      sendingPlaceType: data.sendingPlaceType
      sendingPlaceId: data.sendingPlaceId
      destinationType: data.destinationType
      destinationId: data.destinationId
      resource: data.resource
      amount: data.amount
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