_ = require('lodash')

lib = require('../lib')
Result = lib.Result
Reward = lib.Reward
Requirement = lib.Requirement
balance = lib.balance

Transport = require('../game_data').Transport
TransportType = require('../game_data').TransportType

Player = require('../models').Player

module.exports =
  buy: (player, itemId, itemType, amount)->
    dataResult = {
      item_id: itemId
      item_type: itemType
    }

    requirement = new Requirement()

    switch itemType
      when 'transport'
        itemId = _.toInteger(itemId)
        item = Transport.find(itemId)
        requirement.basicMoney(item.basicPrice)

        # TODO check on capacity

      when 'fuel'
        return new Result(
          error_code: Result.errors.dataNotFound
          # WARNING: without data result
        ) unless itemId in Player.fuelTypes

        return new Result(
          error_code: Result.errors.notReachedLevel
          data: dataResult
        ) if Player.fuelLevels[itemId] > player.level

        # валидация кол-ва топлива
        amount = Math.floor(amount)
        amount = 1 if _.isNaN(amount) || amount < 1

        requirement.basicMoney(balance.fuelBasicPrice(itemId) * amount)

      else
        # если не правильный тип был передан
        return new Result(
          error_code: Result.errors.dataNotFound
          # WARNING: without data result
        )

    unless requirement.isSatisfiedFor(player)
      dataResult.requirement = requirement.unSatisfiedFor(player)

      return new Result(
        error_code: Result.errors.requirementsNotSatisfied
        data: dataResult
      )

    reward = new Reward(player)

    switch itemType
      when 'transport'
        player.transportState.create(item)

      when 'fuel'
        reward.addFuel(itemId, amount)

    requirement.apply(reward)

    dataResult.reward = reward

    new Result(
      data: dataResult
    )