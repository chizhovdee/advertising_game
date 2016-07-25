lib = require('../lib')
Result = lib.Result
Reward = lib.Reward
Requirement = lib.Requirement
balance = lib.balance

Transport = require('../game_data').Transport

module.exports =
  buy: (player, itemId, itemType, amount)->
    console.log itemId
    console.log itemType
    console.log amount

    requirement = new Requirement()

    switch itemType
      when 'transport'
        itemId = _.toInteger(itemId)
        item = Transport.find(itemId)
        requirement.basicMoney(item.basicPrice)

        # TODO check on capacity

      when 'fuel'
        # TODO check amount

        requirement.basicMoney(balance.fuelBasicPrice(itemId) * amount)

        # TODO check on level

    unless requirement.isSatisfiedFor(player)
      return new Result(
        error_code: Result.errors.requirementsNotSatisfied
        data:
          requirement: requirement.unSatisfiedFor(player)
      )


    switch itemType
      when 'transport'
        player.transportState.create(item)

      when 'fuel'
        1


    reward = new Reward(player)
    requirement.apply(reward)

    new Result(
      data:
        reward: reward
    )