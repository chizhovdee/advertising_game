lib = require('../lib')
Result = lib.Result
Reward = lib.Reward
Requirement = lib.Requirement

PropertyType = require('../game_data').PropertyType

module.exports =
  createProperty: (player, propertyTypeId)->
    type = PropertyType.find(propertyTypeId)

    requirement = new Requirement()
    requirement.basicMoney(type.basicPrice)

    unless requirement.isSatisfiedFor(player)
      return new Result(
        error_code: 'requirements_not_satisfied'
        data:
          requirement: requirement.unSatisfiedFor(player)
      )

    reward = new Reward(player)
    player.propertiesState.create(type)
    requirement.apply(reward)

    new Result(
      data:
        reward: reward
    )