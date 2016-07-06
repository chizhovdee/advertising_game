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

  accelerateProperty: (player, propertyId)->
    property = player.propertiesState.find(propertyId)

    return new Result(
      error_code: Result.errors.dataNotFound
    ) unless property?

    type = PropertyType.find(property.typeId)

    dataResult = {type_id: type.id}

    requirement = new Requirement()

    if player.propertiesState.propertyIsBuilding(property)
      requirement.vipMoney(balance.acceleratePrice(player.propertiesState.buildingTimeLeftFor(property)))
    else
      # TODO upgrading accelerate

    unless requirement.isSatisfiedFor(player)
      dataResult.requirement = requirement.unSatisfiedFor(player)

      return new Result(
        error_code: Result.errors.requirementsNotSatisfied
        data: dataResult
      )

    reward = new Reward(player)
    player.propertiesState.accelerateBuilding(propertyId)
    requirement.apply(reward)

    dataResult.reward = reward

    new Result(
      data: dataResult
    )