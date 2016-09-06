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

    else if player.factoriesState().factoryInProduction(factory)
      requirement.vipMoney(balance.acceleratePrice(player.factoriesState().productionTimeLeftFor(factory)))
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
    player.factoriesState().accelerateFactory(factory.id)
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

  startFactory: (player, factoryId, productionNumber)->
    factory = player.factoriesState().findRecord(factoryId)

    return new Result(
      error_code: Result.errors.notCorrectData
    ) unless productionNumber in FactoryType.productionNumbers

    return new Result(
      error_code: Result.errors.dataNotFound
    ) unless factory?

    type = FactoryType.find(factory.factoryTypeId)

    dataResult = {factory_type_id: type.id}

    if checkResult = @.commonChecks(dataResult, player, factory)
      return checkResult

    requirement = type.requirement?.getOn("startProduction#{productionNumber}")

    if requirement? && !requirement.isSatisfiedFor(player, factory.level)
      dataResult.requirement = requirement.unSatisfiedFor(player, factory.level)

      return new Result(
        error_code: Result.errors.requirementsNotSatisfied
        data: dataResult
      )

    reward = new Reward(player)

    player.factoriesState().startFactory(factory.id, productionNumber, type.productions[productionNumber])

    requirement?.apply(reward, factory.level)

    dataResult.reward = reward

    new Result(data: dataResult)

  collectFactory: (player, factoryId)->
    factory = player.factoriesState().findRecord(factoryId)

    return new Result(
      error_code: Result.errors.dataNotFound
    ) unless factory?

    type = FactoryType.find(factory.factoryTypeId)

    dataResult = {factory_type_id: type.id}

    return new Result(
      error_code: Result.errors.factoryCanNotCollect
      data: dataResult
    ) unless player.factoriesState().canCollectFactory(factory)

    reward = new Reward(player)
    type.reward.applyOn("collectProduction#{ factory.productionNumber }", reward, factory.level)
    player.factoriesState().collectFactory(factory.id)

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

    return new Result(
      error_code: Result.errors.factoryInProduction
      data: dataResult
    ) if player.factoriesState().factoryInProduction(factory)

    return new Result(
      error_code: Result.errors.factoryNeedCollect
      data: dataResult
    ) if player.factoriesState().canCollectFactory(factory)

