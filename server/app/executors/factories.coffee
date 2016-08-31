lib = require('../lib')
Result = lib.Result
Reward = lib.Reward
Requirement = lib.Requirement
balance = lib.balance

FactoryType = require('../game_data').FactoryType

module.exports =
  createFactory: (player, factoryTypeId)->
    type = FactoryType.find(factoryTypeId)

    dataResult = {factory_type_id: type.id}

    factory = player.factoriesState().findRecordByFactoryTypeId(factoryTypeId)

    return new Result(
      error_code: Result.errors.factoryIsBuilt
    ) if factory?

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
    player.factoriesState().createFactory(type.id, type.buildDuration)
    requirement.apply(reward)

    dataResult.reward = reward

    new Result(
      data: dataResult
    )

  accelerateFactory: (player, factoryId)->
    factory = player.factoriesState().findRecord(factoryId)

    return new Result(
      error_code: Result.errors.dataNotFound
    ) unless factory?

    type = FactoryType.find(factory.factoryTypeId)

    dataResult = {factory_type_id: type.id}

    requirement = new Requirement()

    if player.factoriesState().factoryIsBuilding(factory)
      requirement.vipMoney(balance.acceleratePrice(player.factoriesState().buildingTimeLeftFor(factory)))

    else if player.factoriesState().factoryIsUpgrading(factory)
      requirement.vipMoney(balance.acceleratePrice(player.factoriesState().upgradingTimeLeftFor(factory)))
    else
    # TODO проверка что вообще нет никакой надобности что либо ускорять

    unless requirement.isSatisfiedFor(player)
      dataResult.requirement = requirement.unSatisfiedFor(player)

      return new Result(
        error_code: Result.errors.requirementsNotSatisfied
        data: dataResult
      )

    reward = new Reward(player)
    player.factoriesState().accelerateBuilding(factory.id)
    requirement.apply(reward)

    dataResult.reward = reward

    new Result(
      data: dataResult
    )

  upgradeFactory: (player, factoryId)->
    factory = player.factoriesState().findRecord(factoryId)

    return new Result(
      error_code: Result.errors.dataNotFound
    ) unless factory?

    type = FactoryType.find(factory.factoryTypeId)

    dataResult = {factory_type_id: type.id}

    if checkResult = @.commonChecks(dataResult, player, factory)
      return checkResult

    return new Result(
      error_code: Result.errors.notReachedLevel
      data: dataResult
    ) if type.upgradeLevelBy(factory.level) > player.level

    requirement = new Requirement()
    requirement.basicMoney(type.upgradePriceBy(factory.level))

    unless requirement.isSatisfiedFor(player)
      dataResult.requirement = requirement.unSatisfiedFor(player)

      return new Result(
        error_code: Result.errors.requirementsNotSatisfied
        data: dataResult
      )

    reward = new Reward(player)
    player.factoriesState().upgradeFactory(factory.id, type.upgradeDurationBy(factory.level))
    requirement.apply(reward)

    dataResult.reward = reward

    new Result(data: dataResult)

  commonChecks: (dataResult, player, factory)->
    return new Result(
      error_code: Result.errors.factoryIsBuilding
      data: dataResult
    ) if player.factoriesState().factoryIsBuilding(factory)

    return new Result(
      error_code: Result.errors.factoryIsUpgrading
      data: dataResult
    ) if player.factoriesState().factoryIsUpgrading(factory)
