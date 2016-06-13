lib = require('../lib')
Result = lib.Result
Reward = lib.Reward
Requirement = lib.Requirement

Transport = require('../game_data').Transport
Route = require('../game_data').Route


module.exports =
  createTrucking: (player, stateRouteId, transportIds, routeId = null)->
    console.log 'stateRouteId', stateRouteId
    console.log 'transportIds', transportIds

    if routeId
      route = Route.find(routeId)
    else
      routeState = player.routesState.find(stateRouteId)
      route = Route.find(routeState.routeId)

      # TODO check routeState expired

    transportList = []
    for tId in transportIds
      tState = player.transportState.find(tId)

      # TODO check tState.truckingId
      # TODO check tState.damage
      transportList.push(Transport.find(tState.typeId))

    attributes = player.truckingState.getTruckingAttributesBy(route, transportList)

    requirement = new Requirement()
    requirement.fuel(attributes.fuel)

    unless requirement.isSatisfiedFor(player)
      return new Result(
        error_code: 'requirements_not_satisfied'
        data:
          requirement: requirement.unSatisfiedFor(player)
      )

    # создание новой грузоперевозки
    truckingId = player.truckingState.create(route, transportIds, attributes.duration)

    # установка каждому транспорту id грузоперевозки
    player.transportState.setTruckingFor(transportIds, truckingId)

    # удаление маршрута
    player.routesState.delete(stateRouteId) if stateRouteId?

    reward = new Reward(player)
    requirement.apply(reward)

    new Result(
      data:
        reward: reward
    )

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