_ = require('lodash')
lib = require('../lib')
Result = lib.Result
Reward = lib.Reward
TownLevel = require('../game_data').TownLevel

module.exports =
  collectBonus: (player)->
    return new Result(
      error_code: Result.errors.townBonusNotAvailable
    ) unless @.canCollectBonus(player)

    reward = new Reward(player)

    reward.giveBasicMoney(@.bonusBasicMoney(player.town_level))

    player.town_bonus_collected_at = new Date()

    new Result(data: {reward: reward})

  # эти методы определены здесь, потому что, они больше нигде не нужны и чтобы не увеличивать размер game_data объектов
  bonusBasicMoney: (townLevel)->
    TownLevel.bonusBasicMoney +
    TownLevel.bonusBasicMoney * (townLevel - 1) *
    TownLevel.bonusFactor

  canCollectBonus: (player)->
    if player.town_bonus_collected_at?
      (player.town_bonus_collected_at.valueOf() + TownLevel.bonusDuration) - Date.now() <= 0

    else
      true