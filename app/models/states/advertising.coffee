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

    @.addOperation('add', newId, @.adToJSON(newRecord))

  updateRouteOpenAt: (id)->
    type = AdvertisingType.find(@state[id].advertisingTypeId)

    @state[id].updatedAt = Date.now()
    @state[id].routeOpenAt = Date.now() + type.timeGeneration

    @.update()

    @.addOperation('update', id, @.adToJSON(@state[id]))

  prolong: (id, duration)->
    @state[id].updatedAt = Date.now()
    @state[id].expireAt = @state[id].expireAt + duration

    @.update()

    @.addOperation('update', id, @.adToJSON(@state[id]))

  count: ->
    _.keys(@state).length

  adIsExpired: (id)->
    @state[id].expireAt <= Date.now()

  canOpenRoute: (id)->
    @state[id].routeOpenAt > Date.now()

  expireTimeLeftFor: (id)->
    @state[id].expireAt - Date.now()

  adToJSON: (ad)->
    record = @.extendRecord(ad)
    record.expireTimeLeft = @.expireTimeLeftFor(ad.id)
    record.nextRouteTimeLeft = record.routeOpenAt - Date.now()

    record

  toJSON: ->
    state = {}

    for id, record of @state
      state[id] = @.adToJSON(record)

    state

module.exports = AdvertisingState