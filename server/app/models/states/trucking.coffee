_ = require('lodash')
BaseState = require('./base')

class TruckingState extends BaseState
  defaultState: {}
  stateName: "trucking"

  selectByDestination: (resource)->
    @.selectRecords((r)->
      r.destinationId == resource.id && r.destinationType == resource.type
    )

  countByDestination: (resource)->
    @.selectByDestination(resource).length

  createTrucking: (data, duration)->
    newId = @.generateId()
    newRecord = {
      id: newId
      transportId: data.transportId
      sendingPlaceType: data.sendingPlaceType
      sendingPlaceId: data.sendingPlaceId
      destinationType: data.destinationType
      destinationId: data.destinationId
      materialTypeKey: data.materialTypeKey
      amount: data.amount
      completeAt: Date.now() + duration
      createdAt: Date.now()
      updatedAt: Date.now()
    }

    @.addRecord(newId, newRecord)

  accelerateTrucking: (id)->
    @state[id].completeAt = Date.now()

    @.updateRecord(id)

  truckingCompleteIn: (trucking)->
    trucking.completeAt - Date.now()

  truckingIsCompleted: (trucking)->
    trucking.completeAt <= Date.now()

  recordToJSON: (record)->
    record = super(record)

    record.completeIn = @.truckingCompleteIn(record)

    record


module.exports = TruckingState