_ = require('lodash')
BaseState = require('./base')

class TruckingState extends BaseState
  defaultState: {}
  stateName: "trucking"

  allForClient: ->
    for id, trucking of @state
      trucking.leftTime = trucking.completeAt - Date.now()

    @state

  createTrucking: (routeId, transportId)->
    @state[_.random(10000000)] = {
      routeId: routeId
      transportId: transportId
      completeAt: Date.now() + _(10).minutes()
    }

    @.update()

module.exports = TruckingState