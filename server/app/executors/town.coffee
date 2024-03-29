_ = require('lodash')
lib = require('../lib')
Result = lib.Result
Reward = lib.Reward
Requirement = lib.Requirement
balance = lib.balance

module.exports =
  collectBonus: (player)->
    return new Result(
      error_code: Result.errors.townBonusNotAvailable
    ) unless player.townState().canCollectBonus()

    reward = new Reward(player)

    reward.giveBasicMoney(player.townState().bonusBasicMoney())

    player.townState().collectBonus()

    new Result(data: {reward: reward})

  upgradeTown: (player)->
    return new Result(
      error_code: Result.errors.townIsUpgrading
    ) if player.townState().isUpgrading()

    return new Result(
      error_code: Result.errors.townCanNotUpgrade
    ) unless player.townState().canUpgrade()

    townResource = player.placesState().resourceFor('town')

    return new Result(
      error_code: Result.errors.townTruckingIsActive
    ) if player.truckingState().countByDestination(townResource) > 0

    reward = new Reward(player, townResource)

    for materialTypeKey, value of player.townState().level().materials
      reward.takeMaterial(materialTypeKey, value)

    player.townState().upgradeTown()
    player.townMaterialsState().destroyAllRecords() # reset all town materials

    new Result(data: {reward: reward})

  accelerateTown: (player)->
    return new Result(
      error_code: Result.errors.accelerationNotAvailable
    ) unless player.townState().isUpgrading()

    requirement = new Requirement()

    requirement.vipMoney(balance.acceleratePrice(player.townState().timeLeftToUpgrading()))

    unless requirement.isSatisfiedFor(player)
      return new Result(
        error_code: Result.errors.requirementsNotSatisfied
        data: {requirement: requirement.unSatisfiedFor(player)}
      )

    reward = new Reward(player)
    requirement.apply(reward)

    player.townState().accelerateTown()

    new Result(
      data: {reward: reward}
    )
