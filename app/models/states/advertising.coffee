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

  create: (type, status, period)->
    newId = @.generateId()
    newResource = {
      typeId: type.id
      status: status
      createdAt: Date.now()
      updatedAt: Date.now()
      expireAt: Date.now() + _(period).hours()
      routeOpenAt: Date.now()
    }

    @state[newId] = newResource

    @.update()

    @.addOperation('add', newId, @.adToJSON(newResource))

  updateRouteOpenAt: (id)->
    type = AdvertisingType.find(@state[id].typeId)

    @state[id].routeOpenAt = Date.now() + type.timeGeneration

    @.update()

    @.addOperation('update', id, @.adToJSON(@state[id]))

  adIsExpired: (id)->
    @state[id].expireAt <= Date.now()

  canOpenRoute: (id)->
    @state[id].routeOpenAt > Date.now()

  adToJSON: (ad)->
    resource = _.clone(ad)
    resource.expireTimeLeft = resource.expireAt - Date.now()
    resource.nextRouteTimeLeft = resource.routeOpenAt - Date.now()

    resource

  toJSON: ->
    state = {}

    for id, resource of @state
      state[id] = @.adToJSON(resource)

    state

module.exports = AdvertisingState