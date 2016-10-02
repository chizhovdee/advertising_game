_ = require('lodash')
lib = require('../lib')
Result = lib.Result
Reward = lib.Reward
Requirement = lib.Requirement
geometry = lib.geometry
balance = lib.balance

gameData = require('../game_data')
TransportModel = gameData.TransportModel
FactoryType = gameData.FactoryType
PropertyType = gameData.PropertyType
PlaceType = gameData.PlaceType
TownLevel = gameData.TownLevel
MaterialType = gameData.MaterialType

module.exports =
  createTrucking: (player, data)->
    console.log 'DATA', data

    dataResult = {}

    transport = player.transportState().findRecord(data.transport_id)
    transportModel = TransportModel.find(transport.transportModelId)

    destination = player.stateByType(data.destination.type).findRecord(data.destination.id)
    destinationType = @.findGameDataTypeFor(destination, data.destination.type)

    sendingPlaceState = player.stateByType(data.sending_place.type)
    sendingPlace = sendingPlaceState.findRecord(data.sending_place.id)
    sendingPlaceStateResource = sendingPlaceState.resourceFor(sendingPlace.id)
    sendingPlaceType = @.findGameDataTypeFor(sendingPlace, data.sending_place.type)

    distance = geometry.pDistance(sendingPlaceType.position, destinationType.position)
    travelTime = _(Math.ceil(distance / transportModel.travelSpeed * 60)).minutes()

    requirement = new Requirement()
    requirement.material(data.material, data.amount)

    if requirement? && !requirement.isSatisfiedFor(player, sendingPlaceStateResource)
      dataResult.requirement = requirement.unSatisfiedFor(player, sendingPlaceStateResource)

      return new Result(
        error_code: Result.errors.requirementsNotSatisfied
        data: dataResult
      )

    reward = new Reward(player, sendingPlaceStateResource)

    requirement?.apply(reward)

    dataResult.reward = reward

    player.truckingState().createTrucking(
      transportId: data.transport_id
      sendingPlaceType: data.sending_place.type
      sendingPlaceId: data.sending_place.id
      destinationType: data.destination.type
      destinationId: data.destination.id
      materialTypeKey: data.material
      amount: data.amount
      ,
      travelTime
    )

    new Result(data: dataResult)

  collectTrucking: (player, truckingId)->
    trucking = player.truckingState().findRecord(truckingId)

    return new Result(
      error_code: Result.errors.dataNotFound
    ) unless trucking?

    destinationState = player.stateByType(trucking.destinationType)

    destination = destinationState.findRecord(trucking.destinationId)

    reward = new Reward(player, destinationState.resourceFor(destination.id))

    if destination.id == 'town'
      townLevel = TownLevel.findByNumber(player.town_level)

      unless townLevel.isContainMaterial(trucking.materialTypeKey)
        materialType = MaterialType.find(trucking.materialTypeKey)

        if materialType.townLevel >= townLevel.number
          reward.giveBasicMoney(materialType.sellBasicPrice * trucking.amount)

          player.townMaterialsState().addMaterial(trucking.materialTypeKey, trucking.amount)

          player.townMaterialsState().destroyExpiredMaterials()

    if !townLevel || townLevel.isContainMaterial(trucking.materialTypeKey)
      reward.giveMaterial(trucking.materialTypeKey, trucking.amount)

    player.truckingState().deleteRecord(trucking.id)

    new Result(
      data:
        reward: reward
    )

  accelerateTrucking: (player, truckingId)->
    trucking = player.truckingState().findRecord(truckingId)

    return new Result(
      error_code: Result.errors.dataNotFound
    ) unless trucking?

    requirement = new Requirement()

    if not player.truckingState().truckingIsCompleted(trucking)
      requirement.vipMoney(balance.acceleratePrice(player.truckingState().truckingCompleteIn(trucking)))

    else
      return new Result(
        error_code: Result.errors.accelerationNotAvailable
      )

    unless requirement.isSatisfiedFor(player)
      requirement = requirement.unSatisfiedFor(player)

      return new Result(
        error_code: Result.errors.requirementsNotSatisfied
        data: {requirement: requirement}
      )

    reward = new Reward(player)
    player.truckingState().accelerateTrucking(trucking.id)

    requirement.apply(reward)

    new Result(data: {reward: reward})

  findGameDataTypeFor: (record, type)->
    switch type
      when 'factories'
        FactoryType.find(record.factoryTypeId)
      when 'properties'
        PropertyType.find(record.propertyTypeId)
      when 'places'
        PlaceType.find(record.placeTypeKey)

