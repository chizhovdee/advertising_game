lib = require('../lib')
Result = lib.Result
Reward = lib.Reward
Requirement = lib.Requirement

#Transport = require('../game_data').Transport
#Route = require('../game_data').Route

module.exports =
  createTrucking: (player, routeId, transportId)->
    console.log 'routeId', routeId
    console.log 'transportId', transportId

    console.log player.truckingState

    player.truckingState.createTrucking(routeId, transportId)

    new Result()