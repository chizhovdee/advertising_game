lib = require('../lib')
Result = lib.Result
Reward = lib.Reward
Requirement = lib.Requirement

Transport = require('../game_data').Transport
Route = require('../game_data').Route


module.exports =
  createTrucking: (player)->

    new Result()

  collectTrucking: (player, truckingId)->
    trucking = player.truckingState.find(truckingId)

    # TODO return error unless trucking?

    route = Route.find(trucking.routeId)

    reward = new Reward(player)
    route.reward.applyOn('collect', reward)

    player.truckingState.delete(truckingId)

    # TODO remove trucking id from transport

    new Result(
      data:
        reward: reward
    )