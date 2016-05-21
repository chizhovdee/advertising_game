lib = require('../lib')
Result = lib.Result
Reward = lib.Reward
Requirement = lib.Requirement

module.exports =
  create: (player, data)->
    new Result()