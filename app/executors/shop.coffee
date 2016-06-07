lib = require('../lib')
Result = lib.Result
Reward = lib.Reward
Requirement = lib.Requirement

module.exports =
  buy: (player, itemId)->
    new Result()