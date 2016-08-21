_ = require('lodash')
BaseState = require('./base')
AdvertisingType = require('../../game_data').AdvertisingType

class AdvertisingState extends BaseState
  defaultState: {}
  stateName: "advertising"

  generateId: ->
    super(_.keys(@state))

  create: (advertisingTypeId, status, duration)->
    newId = @.generateId()
    newRecord = {
      id: newId
      advertisingTypeId: advertisingTypeId
      status: status
      createdAt: Date.now()
      updatedAt: Date.now()
      expireAt: Date.now() + duration
      routeOpenAt: Date.now()
    }

    @state[newId] = newRecord

    @.update()

    @.addOperation('add', newId, @.recordToJSON(newRecord))

  updateRouteOpenAt: (id)->
    # TODO вынести type.timeGeneration за пределы этой функции
    #type = AdvertisingType.find(@state[id].advertisingTypeId)

    @state[id].updatedAt = Date.now()
    @state[id].routeOpenAt = Date.now() + type.timeGeneration

    @.update()

    @.addOperation('update', id, @.recordToJSON(@state[id]))

  prolong: (id, duration)->
    @state[id].updatedAt = Date.now()
    @state[id].expireAt = @state[id].expireAt + duration

    @.update()

    @.addOperation('update', id, @.recordToJSON(@state[id]))

  adIsExpired: (id)->
    @state[id].expireAt <= Date.now()

  canOpenRoute: (id)->
    @state[id].routeOpenAt > Date.now()

  expireTimeLeftFor: (id)->
    @state[id].expireAt - Date.now()

  recordToJSON: (record)->
    record = super(record)
    record.expireTimeLeft = @.expireTimeLeftFor(record.id)
    record.nextRouteTimeLeft = record.routeOpenAt - Date.now()

    record

  toJSON: ->
    state = {}

    for id, record of @state
      state[id] = @.recordToJSON(record)

    state

module.exports = AdvertisingState