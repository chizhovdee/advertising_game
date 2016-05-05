_ = require('lodash')
BaseState = require('./base')

class TruckingState extends BaseState
  defaultState: {}

  stateName: "trucking"

  all: ->
    @state

  createTrucking: (routeId, transportId)->
    @state[_.random(10000000)] = {
      routeId: routeId
      transportId: transportId
      completeAt: Date.now() + _(5).minutes()
    }

    @.update()

module.exports = TruckingState