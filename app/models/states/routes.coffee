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
    delete @state[id]

    @.addOperation('delete', id)

    @.update()

  routeToJSON: (ad)->
    resource = @.extendResource(ad)
    resource.expireTimeLeft = (resource.createdAt + RoutesState.expireDuration) - Date.now()

    resource

  toJSON: ->
    state = {}

    for id, resource of @state
      state[id] = @.routeToJSON(resource)

    state

module.exports = RoutesState