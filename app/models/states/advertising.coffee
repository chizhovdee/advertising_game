_ = require('lodash')
BaseState = require('./base')
AdvertisingType = require('../../game_data').AdvertisingType

class AdvertisingState extends BaseState
  defaultState: {}
  stateName: "advertising"

  generateId: ->
    super(_.keys(@state))

  find: (id)->
    # TODO replace on findRecord from baseState
    @state[id]

  create: (advertisingType, status, period)->
    newId = @.generateId()
    newRecord = {
      id: newId
      typeId: advertisingType.id
      status: status
      createdAt: Date.now()
      updatedAt: Date.now()
      expireAt: Date.now() + _(period).days()
      routeOpenAt: Date.now()
    }

    @state[newId] = newRecord

    @.update()

    @.addOperation('add', newId, @.adToJSON(newRecord))

    newRecord # return new record

  updateRouteOpenAt: (id)->
    type = AdvertisingType.find(@state[id].typeId)

    @state[id].updatedAt = Date.now()
    @state[id].routeOpenAt = Date.now() + type.timeGeneration

    @.update()

    @.addOperation('update', id, @.adToJSON(@state[id]))

  prolong: (id, period)->
    @state[id].updatedAt = Date.now()
    @state[id].expireAt = @state[id].expireAt + _(period).days()

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