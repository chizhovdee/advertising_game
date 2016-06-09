lib = require('../lib')
Result = lib.Result
Reward = lib.Reward
Requirement = lib.Requirement

Transport = require('../game_data').Transport

module.exports =
  buy: (player, itemId)->
    item = Transport.find(itemId)

    requirement = new Requirement()
    requirement.basicMoney(item.basicPrice)

    unless requirement.isSatisfiedFor(player)
      return new Result(
        error_code: 'requirements_not_satisfied'
        data:
          requirement: requirement.unSatisfiedFor(player)
      )

    reward = new Reward(player)
    player.transportState.create(item)
    requirement.apply(reward)

    new Result(
      data:
        reward: reward
    )