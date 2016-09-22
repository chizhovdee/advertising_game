_ = require('lodash')
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
    sendingPlaceType = @.findGameDataTypeFor(sendingPlace, data.sending_place.type)

    distance = geometry.pDistance(sendingPlaceType.position, destinationType.position)
    travelTime = _(Math.ceil(distance / transportModel.travelSpeed * 60)).minutes()

    player.truckingState().createTrucking(
      transportId: data.transport_id
      sendingPlaceType: data.sending_place.type
      sendingPlaceId: data.sending_place.id
      destinationType: data.destination.type
      destinationId: data.destination.id
      resource: data.resource
      amount: data.amount
      ,
      travelTime
    )

    new Result()

  collectTrucking: (player, truckingId)->
    trucking = player.truckingState().findRecord(truckingId)

    destinationState = player.stateByType(trucking.destinationType)

    destination = destinationState.findRecord(trucking.destinationId)

    reward = new Reward(player, destinationState.resourceFor(destination.id))
    reward.giveMaterial(trucking.resource, trucking.amount)

    player.truckingState().deleteRecord(trucking.id)

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


