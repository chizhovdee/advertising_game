_ = require('lodash')

lib = require('../lib')
Result = lib.Result
Reward = lib.Reward
Requirement = lib.Requirement
balance = lib.balance

TransportModel = require('../game_data').TransportModel
PropertyType = require('../game_data').PropertyType

Player = require('../models').Player

module.exports =
  purchaseTransport: (player, transportModelId)->
    dataResult = {
      transport_model_id: transportModelId
    }

    requirement = new Requirement()

    transportModelId = _.toInteger(transportModelId)
    transportModel = TransportModel.find(transportModelId)

    # check level
    return new Result(
      error_code: Result.errors.notReachedLevel
      data: dataResult
    ) if transportModel.level > player.level

    propertyType = PropertyType.find('garage')
    property = player.propertiesState().findRecordByPropertyTypeId(propertyType.id)

    # check capacity
    if player.transportState().recordsCount() >= propertyType.fullCapacityBy(property)
      return new Result(
        error_code: Result.errors.noFreePlaces
        data: dataResult
      )

    requirement.basicMoney(transportModel.basicPrice)

    # check money
    unless requirement.isSatisfiedFor(player)
      dataResult.requirement = requirement.unSatisfiedFor(player)

      return new Result(
        error_code: Result.errors.requirementsNotSatisfied
        data: dataResult
      )

    reward = new Reward(player)

    player.transportState().addTransport(transportModel.id)

    requirement.apply(reward)

    dataResult.reward = reward

    new Result(
      data: dataResult
    )
