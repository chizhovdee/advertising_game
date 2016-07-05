lib = require('../lib')
Result = lib.Result
Reward = lib.Reward
Requirement = lib.Requirement
balance = lib.balance

PropertyType = require('../game_data').PropertyType

module.exports =
  createProperty: (player, propertyTypeId)->
    type = PropertyType.find(propertyTypeId)

    dataResult = {type_id: type.id}

    return new Result(
      error_code: Result.errors.notReachedLevel
      data: dataResult
    ) if type.buildLevel > player.level

    requirement = new Requirement()
    requirement.basicMoney(type.basicPrice)

    unless requirement.isSatisfiedFor(player)
      dataResult.requirement = requirement.unSatisfiedFor(player)

      return new Result(
        error_code: Result.errors.requirementsNotSatisfied
        data: dataResult
      )

    reward = new Reward(player)
    player.propertiesState.create(type)
    requirement.apply(reward)

    dataResult.reward = reward

    new Result(
      data: dataResult
    )

  accelerateProperty: (player, propertyTypeId)->
    type = PropertyType.find(propertyTypeId)

    dataResult = {type_id: type.id}

    requirement = new Requirement()
    requirement.vipMoney(balance.acceleratePrice(player.propertiesState))

    unless requirement.isSatisfiedFor(player)
      dataResult.requirement = requirement.unSatisfiedFor(player)

      return new Result(
        error_code: Result.errors.requirementsNotSatisfied
        data: dataResult
      )

    reward = new Reward(player)
    player.propertiesState.create(type)
    requirement.apply(reward)

    dataResult.reward = reward

    new Result(
      data: dataResult
    )