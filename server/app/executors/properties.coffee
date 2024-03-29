lib = require('../lib')
Result = lib.Result
Reward = lib.Reward
Requirement = lib.Requirement
balance = lib.balance

PropertyType = require('../game_data').PropertyType

module.exports =
  createProperty: (player, propertyTypeId)->
    type = PropertyType.find(propertyTypeId)

    dataResult = {property_type_id: type.id}

    property = player.propertiesState().findRecordByPropertyTypeId(propertyTypeId)

    return new Result(
      error_code: Result.errors.propertyIsBuilt
    ) if property?

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
    player.propertiesState().createProperty(type.id, type.buildDuration)
    requirement.apply(reward)

    dataResult.reward = reward

    new Result(
      data: dataResult
    )

  accelerateProperty: (player, propertyId)->
    property = player.propertiesState().findRecord(propertyId)

    return new Result(
      error_code: Result.errors.dataNotFound
    ) unless property?

    type = PropertyType.find(property.propertyTypeId)

    dataResult = {property_type_id: type.id}

    requirement = new Requirement()

    if player.propertiesState().propertyIsBuilding(property)
      requirement.vipMoney(balance.acceleratePrice(player.propertiesState().buildingTimeLeftFor(property)))
    else if player.propertiesState().propertyIsUpgrading(property)
      requirement.vipMoney(balance.acceleratePrice(player.propertiesState().upgradingTimeLeftFor(property)))
    else
      return new Result(
        error_code: Result.errors.accelerationNotAvailable
        data: dataResult
      )

    unless requirement.isSatisfiedFor(player)
      dataResult.requirement = requirement.unSatisfiedFor(player)

      return new Result(
        error_code: Result.errors.requirementsNotSatisfied
        data: dataResult
      )

    reward = new Reward(player)
    player.propertiesState().accelerateBuilding(propertyId)
    requirement.apply(reward)

    dataResult.reward = reward

    new Result(
      data: dataResult
    )

  upgradeProperty: (player, propertyId)->
    property = player.propertiesState().findRecord(propertyId)

    return new Result(
      error_code: Result.errors.dataNotFound
    ) unless property?

    type = PropertyType.find(property.propertyTypeId)

    dataResult = {property_type_id: type.id}

    if checkResult = @.commonChecks(dataResult, player, property)
      return checkResult

    return new Result(
      error_code: Result.errors.notReachedLevel
      data: dataResult
    ) if type.upgradeLevelBy(property.level) > player.level

    requirement = new Requirement()
    requirement.basicMoney(type.upgradePriceBy(property.level))

    unless requirement.isSatisfiedFor(player)
      dataResult.requirement = requirement.unSatisfiedFor(player)

      return new Result(
        error_code: Result.errors.requirementsNotSatisfied
        data: dataResult
      )

    reward = new Reward(player)
    player.propertiesState().upgrade(propertyId, type.upgradeDurationBy(property.level))
    requirement.apply(reward)

    dataResult.reward = reward

    new Result(data: dataResult)

  commonChecks: (dataResult, player, property)->
    return new Result(
      error_code: Result.errors.propertyIsBuilding
      data: dataResult
    ) if player.propertiesState().propertyIsBuilding(property)

    return new Result(
      error_code: Result.errors.propertyIsUpgrading
      data: dataResult
    ) if player.propertiesState().propertyIsUpgrading(property)
