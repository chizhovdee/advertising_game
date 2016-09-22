lib = require('../lib')
Result = lib.Result
Reward = lib.Reward
Requirement = lib.Requirement
geometry = lib.geometry

gameData = require('../game_data')
TransportModel = gameData.TransportModel
FactoryType = gameData.FactoryType
PropertyType = gameData.PropertyType

module.exports =
  createTrucking: (player, data)->
    console.log 'DATA', data

    transport = player.transportState().findRecord(data.transport_id)
    transportModel = TransportModel.find(transport.transportModelId)

    destination = player.stateByType(data.destination.type).findRecord(data.destination.id)
    destinationType = @.findGameDataTypeFor(destination, data.destination.type)

    sendingPlace = player.stateByType(data.sending_place.type).findRecord(data.sending_place.id)
    sendingPlaceType = 1

    duration = Math.ceil(geometry transportModel.travelSpeed)

    player.truckingState().createTrucking(
      transportId: data.transport_id
      sendingPlaceType: data.sending_place.type
      sendingPlaceId: data.sending_place.id
      destinationType: data.destination.type
      destinationId: data.destination.id
      resource: data.resource
      amount: data.amount
      duration: duration
    )

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

  findGameDataTypeFor: (record, type)->
    switch type
      when 'factories'
        FactoryType.find(record.factoryTypeId)
      when 'properties'
        PropertyType.find(record.propertyTypeId)


