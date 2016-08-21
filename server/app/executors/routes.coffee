lib = require('../lib')
Result = lib.Result
Reward = lib.Reward
Requirement = lib.Requirement

module.exports =
  openRoute: (player, advertisingId)->
    ad = player.advertisingState.findRecord(advertisingId)

    return new Result(error_code: Result.errors.dataNotFound) unless ad?

    if player.advertisingState.adIsExpired(advertisingId)
      return new Result(error_code: Result.errors.advertisingExpired)

    if player.advertisingState.canOpenRoute(advertisingId)
      return new Result(error_code: Result.errors.routeCanNotOpen)

    player.routesState.selectAndCreateRoute(ad.status)
    player.advertisingState.updateRouteOpenAt(advertisingId)

    new Result() # empty result