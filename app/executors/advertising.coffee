lib = require('../lib')
Result = lib.Result
Reward = lib.Reward
Requirement = lib.Requirement

AdvertisingType = require('../game_data').AdvertisingType

module.exports =
  create: (player, data)->
    type = AdvertisingType.find(data.type)
    status = data.status
    period = data.period
    period = AdvertisingType.periods[0] if period < AdvertisingType.periods[0]

    requirement = new Requirement()
    requirement.basicMoney(type.price(status, period))

    unless requirement.isSatisfiedFor(player)
      return new Result(
        error_code: 'requirements_not_satisfied'
        data:
          requirement: requirement.unSatisfiedFor(player)
      )

    reward = new Reward(player)
    player.advertisingState.create(type, status, period)
    requirement.apply(reward)

    new Result(
      data:
        reward: reward
    )
