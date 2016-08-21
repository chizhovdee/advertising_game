_ = require('lodash')
BaseState = require('./base')

class TruckingState extends BaseState
  defaultState: {}
  stateName: "trucking"

  find: (id)->
    @state[id]

  create: (route, stateTransportIds, duration)->
    newId = @.generateId()
    newRecord = {
      id: newId
      routeId: route.id
      transportIds: stateTransportIds
      completeAt: Date.now() + duration
      createdAt: Date.now()
      updatedAt: Date.now()
    }

    @state[newId] = newRecord

    @.addOperation('add', newId, @.recordToJSON(newRecord))

    @.update()

    newId # return new trucking id

  getTruckingAttributesBy: (route, transportList)->
    fuel = 0
    duration = 0 # TODO при поезде каждый транспорт должен уменьшать скорость на определенный процент

    for transport in transportList
      fuel += Math.ceil((transport.consumption / 100) * route.distance)
      duration = Math.ceil((_(1).hours() / transport.travelSpeed) * route.distance)

    {fuel: fuel, duration: duration}

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