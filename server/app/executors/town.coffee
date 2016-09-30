_ = require('lodash')
lib = require('../lib')
Result = lib.Result
Reward = lib.Reward

module.exports =
  collectBonus: (player)->

    reward = new Reward(player)

    reward.giveBasicMoney(100)

    new Result(data: {reward: reward})