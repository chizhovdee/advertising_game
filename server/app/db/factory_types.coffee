_ = require("lodash")
FactoryType = require('../game_data').FactoryType

FactoryType.define('coal_factory', (obj)->
  obj.basicPrice = 1000
  obj.buildLevel = 1
  obj.buildDuration = _(1).minutes()
  obj.upgradePerLevels = 5
  obj.baseUpgradeDuration = _(1).minutes()
)

FactoryType.define('wood_factory', (obj)->
  obj.basicPrice = 1000
  obj.buildLevel = 2
  obj.buildDuration = _(1).minutes()
  obj.upgradePerLevels = 5
  obj.baseUpgradeDuration = _(1).minutes()
)