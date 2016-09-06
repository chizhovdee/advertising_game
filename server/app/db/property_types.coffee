PropertyType = require('../game_data').PropertyType
_ = require('lodash')

PropertyType.define('command_center', (obj)->
  obj.basicPrice = 1000
  obj.buildLevel = 1
  obj.buildDuration = _(1).minutes()
  obj.baseCapacity = 2
  obj.freeCapacity = 2
  obj.upgradePerLevels = 5
  obj.baseUpgradeDuration = _(1).minutes()
)

PropertyType.define('garage', (obj)->
  obj.basicPrice = 500
  obj.buildLevel = 1
  obj.buildDuration = _(1).minutes()
  obj.baseCapacity = 2
  obj.freeCapacity = 2
  obj.upgradePerLevels = 5
  obj.baseUpgradeDuration = _(1).minutes()
)

PropertyType.define('warehouse', (obj)->
  obj.basicPrice = 1000
  obj.buildLevel = 2
  obj.buildDuration = _(1).minutes()
  obj.baseCapacity = 5
  obj.freeCapacity = 2
  obj.upgradePerLevels = 5
  obj.baseUpgradeDuration = _(1).minutes()
)

