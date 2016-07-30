_ = require('lodash')
BaseState = require('./base')
AdvertisingType = require('../../game_data').AdvertisingType

class AdvertisingState extends BaseState
  defaultState: {}
  stateName: "advertising"

  generateId: ->
    super(_.keys(@state))

  find: (id)->
    @state[id]

  create: (advertisingType, status, period)->
    newId = @.generateId()
    newResource = {
      typeId: advertisingType.id
      status: status
      createdAt: Date.now()
      updatedAt: Date.now()
      expireAt: Date.now() + _(period).days()
      routeOpenAt: Date.now()
    }

    @state[newId] = newResource

    @.update()

    @.addOperation('add', newId, @.adToJSON(newResource))

  updateRouteOpenAt: (id)->
    type = AdvertisingType.find(@state[id].typeId)

    @state[id].updatedAt = Date.now()
    @state[id].routeOpenAt = Date.now() + type.timeGeneration

    @.update()

    @.addOperation('update', id, @.adToJSON(@state[id]))

  count: ->
    _.keys(@state).length

  adIsExpired: (id)->
    @state[id].expireAt <= Date.now()

  canOpenRoute: (id)->
    @state[id].routeOpenAt > Date.now()

  adToJSON: (ad)->
    resource = @.extendResource(ad)
    resource.expireTimeLeft = resource.expireAt - Date.now()
    resource.nextRouteTimeLeft = resource.routeOpenAt - Date.now()

    resource

  toJSON: ->
    state = {}

    for id, resource of @state
      state[id] = @.adToJSON(resource)

    state

module.exports = AdvertisingState