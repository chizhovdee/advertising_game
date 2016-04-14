lib = require('../lib')
Result = lib.Result
Reward = lib.Reward
Requirement = lib.Requirement

EmployeeType = require('../game_data').EmployeeType

module.exports =
  hire: (player, employeeType, packageNumber)-> # package is reserved WORD
    console.log type = EmployeeType.find(employeeType)

    console.log player.staffState

    new Result()