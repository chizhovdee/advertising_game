lib = require('../lib')
Result = lib.Result
Reward = lib.Reward
Requirement = lib.Requirement

#Transport = require('../game_data').Transport
Route = require('../game_data').Route

module.exports =
  createTrucking: (player, routeId, transportId)->
    console.log 'routeId', routeId
    console.log 'transportId', transportId

    console.log player.truckingState

    player.truckingState.createTrucking(routeId, transportId)

    new Result()

  collectTrucking: (player, truckingId)->

    trucking = player.truckingState.findTtrucking(truckingId)

    # TODO return error unless trucking?

    route = Route.find(trucking.routeId)

    reward = new Reward(player)
    route.reward.applyOn('collect', reward)

    player.truckingState.deleteTrucking(truckingId)

    new Result(
      data:
        reward: reward
        trucking_id: truckingId
    )