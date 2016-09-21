_ = require('lodash')
BaseState = require('./base')

class TruckingState extends BaseState
  defaultState: {}
  stateName: "trucking"

  find: (id)->
    @state[id]

  create: (stateTransportIds, duration)->
    newId = @.generateId()
    newRecord = {
      id: newId
      transportIds: stateTransportIds
      completeAt: Date.now() + duration
      createdAt: Date.now()
      updatedAt: Date.now()
    }

    @state[newId] = newRecord

    @.addOperation('add', newId, @.recordToJSON(newRecord))

    @.update()

    newId # return new trucking id

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