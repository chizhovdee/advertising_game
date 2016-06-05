lib = require('../lib')
Result = lib.Result
Reward = lib.Reward
Requirement = lib.Requirement

module.exports =
  openRoute: (player, advertisingId)->
    ad = player.advertisingState.find(advertisingId)

    return new Result(error_code: 'advertising_not_found') unless ad?

    if player.advertisingState.adIsExpired(advertisingId)
      return new Result(error_code: 'advertising_expired')

    if player.advertisingState.canOpenRoute(advertisingId)
      return new Result(error_code: 'route_can_not_open')

    player.routesState.selectAndCreateRoute(ad.status)
    player.advertisingState.updateRouteOpenAt(advertisingId)

    new Result() # empty result