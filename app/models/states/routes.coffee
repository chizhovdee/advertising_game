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

  generateId: ->
    super(_.keys(@state))

  find: (id)->
    @state[id]

  create: (route)->
    newId = @.generateId()
    newResource = {
      routeId: route.id
      createdAt: Date.now()
    }

    @state[newId] = newResource

    @.addOperation('add', newId, @.routeToJSON(newResource))

    @.update()

  delete: (id)->
    # TODO replace on deleteRecord from baseState
    delete @state[id]

    @.addOperation('delete', id)

    @.update()

  routeToJSON: (ad)->
    record = @.extendRecord(ad)
    record.expireTimeLeft = (record.createdAt + RoutesState.expireDuration) - Date.now()

    record

  toJSON: ->
    state = {}

    for id, record of @state
      state[id] = @.routeToJSON(record)

    state

module.exports = RoutesState