PropertyType = require('../game_data').PropertyType
_ = require('lodash')

PropertyType.define('garage', (obj)->
  obj.basicPrice = 500
  obj.buildLevel = 1
  obj.buildDuration = _(100).minutes()
  obj.baseCapacity = 2
  obj.upgradePerLevels = 5
  obj.upgradeDuration = _(10).minutes()
)

PropertyType.define('command_center', (obj)->
  obj.basicPrice = 1000
  obj.buildLevel = 2
  obj.buildDuration = _(10).minutes()
  obj.baseCapacity = 2
  obj.upgradePerLevels = 5
  obj.upgradeDuration = _(30).minutes()
)

PropertyType.define('warehouse', (obj)->
  obj.basicPrice = 1000
  obj.buildLevel = 2
  obj.buildDuration = _(10).minutes()
  obj.baseCapacity = 5
  obj.upgradePerLevels = 5
  obj.upgradeDuration = _(30).minutes()
)

PropertyType.define('sea_port', (obj)->
  obj.basicPrice = 5000
  obj.buildLevel = 10
  obj.buildDuration = _(30).minutes()
  obj.baseCapacity = 5
  obj.upgradePerLevels = 5
  obj.upgradeDuration = _(1).hours()
)

PropertyType.define('hangar', (obj)->
  obj.basicPrice = 5000
  obj.buildLevel = 10
  obj.buildDuration = _(30).minutes()
  obj.baseCapacity = 5
  obj.upgradePerLevels = 5
  obj.upgradeDuration = _(1).hours()
)

PropertyType.define('train_depot', (obj)->
  obj.basicPrice = 5000
  obj.buildLevel = 10
  obj.buildDuration = _(30).minutes()
  obj.baseCapacity = 5
  obj.upgradePerLevels = 5
  obj.upgradeDuration = _(1).hours()
)

