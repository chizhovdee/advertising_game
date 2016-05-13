_ = require('lodash')
BaseState = require('./base')

class TruckingState extends BaseState
  defaultState: {}
  stateName: "trucking"

  allForClient: ->
    for id, trucking of @state
      trucking.leftTime = trucking.completeAt - Date.now()

    @state

  findTtrucking: (id)->
    @state[id]

  deleteTrucking: (id)->
    delete @state[id]

    @.update()

  createTrucking: (routeId, transportId)->
    @state[_.random(10000000)] = {
      routeId: routeId
      transportId: transportId
      completeAt: Date.now() + _(0.2).minutes()
    }

    @.update()

module.exports = TruckingState