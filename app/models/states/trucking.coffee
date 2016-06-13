_ = require('lodash')
BaseState = require('./base')

class TruckingState extends BaseState
  defaultState: {}
  stateName: "trucking"

  generateId: ->
    super(_.keys(@state))

  create: (route, stateTransportIds, duration)->
    newId = @.generateId()
    newResource = {
      routeId: route.id
      transportIds: stateTransportIds
      completeAt: Date.now() + duration
      createdAt: Date.now()
      updatedAt: Date.now()
    }

    @state[newId] = newResource

    @.update()

    @.addOperation('add', newId, @.truckingToJSON(newResource))

    newId # return new trucking id

  getTruckingAttributesBy: (route, transportList)->
    fuel = 0
    duration = 0 # TODO при поезде каждый транспорт должен уменьшать скорость на определенный процент

    for transport in transportList
      fuel += Math.ceil((transport.consumption / 100) * route.distance)
      duration = Math.ceil((_(1).hours() / transport.travelSpeed) * route.distance)

    {fuel: fuel, duration: duration}

  truckingToJSON: (transport)->
    resource = @.extendResource(transport)

    # custom extend here

    resource

  toJSON: ->
    state = {}

    for id, resource of @state
      state[id] = @.truckingToJSON(resource)

    state

module.exports = TruckingState