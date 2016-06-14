PropertyType = require('../game_data').PropertyType
_ = require('lodash')

PropertyType.define('command_center', (obj)->
  obj.basicPrice = 1000
  obj.buildLevel = 1
  obj.buildDuration = _(1).minutes()
)

PropertyType.define('warehouse', (obj)->
#  obj.basicPrice = 1000
#  obj.baseCargoCount = 10
#  obj.buildLevel = 1
#  obj.improvementPerPlayerLevels = 5
#  obj.employeeTypeKey = 'warehouse_manager'
)

PropertyType.define('garage', (obj)->
#  obj.transportTypeKey = 'auto'
#
#  obj.price = 1000
#  obj.baseTransportsCount = 5
#  obj.buildLevel = 1
#  obj.improvementPerPlayerLevels = 5
#  obj.employeeTypeKey = 'garage_manager'
)

PropertyType.define('sea_port', (obj)->
#  obj.transportTypeKey = 'sea'
#
#  obj.price = 10000
#  obj.baseTransportsCount = 2
#  obj.buildLevel = 50
#  obj.improvementPerPlayerLevels = 5
#  obj.employeeTypeKey = 'sea_port_manager'
)

PropertyType.define('hangar', (obj)->
#  obj.transportTypeKey = 'air'
#
#  obj.price = 10000
#  obj.baseTransportsCount = 2
#  obj.buildLevel = 50
#  obj.improvementPerPlayerLevels = 5
#  obj.employeeTypeKey = 'hangar_manager'
)

PropertyType.define('train_depot', (obj)->
#  obj.transportTypeKey = 'railway'
#
#  obj.price = 10000
#  obj.baseTransportsCount = 2
#  obj.buildLevel = 50
#  obj.improvementPerPlayerLevels = 5
#  obj.employeeTypeKey = 'train_depot_manager'
)

