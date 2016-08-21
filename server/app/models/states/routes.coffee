_ = require('lodash')
BaseState = require('./base')
RouteType = require('../../game_data').RouteType

class RoutesState extends BaseState
  defaultState: {}
  stateName: "routes"

  @expireDuration: _(6).hours()

  selectAndCreateRoute: (typeKey)->
    route = @.selectRoute(typeKey)

    @.create(route)

  selectRoute: (typeKey)->
    type = RouteType.find(typeKey)

    _.chain(type.routes)
      .filter((route)=> route.reputation <= @player.reputation)
      .sample()
      .value()

  create: (route)->
    newId = @.generateId()
    newRecord = {
      id: newId
      routeId: route.id
      createdAt: Date.now()
    }

    @state[newId] = newRecord

    @.addOperation('add', newId, @.recordToJSON(newRecord))

    @.update()

  recordToJSON: (record)->
    record = super(record)
    record.expireTimeLeft = (record.createdAt + RoutesState.expireDuration) - Date.now()

    record

  toJSON: ->
    state = {}

    for id, record of @state
      state[id] = @.recordToJSON(record)

    state

module.exports = RoutesState