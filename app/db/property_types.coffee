PropertyType = require('../game_data').PropertyType

PropertyType.define('storehouse', (obj)->
  obj.price = 1000
  obj.baseCargoCount = 10
  obj.buildLevel = 1
  obj.improvementPerPlayerLevels = 5
)

PropertyType.define('garage', (obj)->
  obj.transportTypeKey = 'auto'

  obj.price = 1000
  obj.baseTransportsCount = 5
  obj.buildLevel = 1
  obj.improvementPerPlayerLevels = 5
)

PropertyType.define('port', (obj)->
  obj.transportTypeKey = 'sea'

  obj.price = 10000
  obj.baseTransportsCount = 2
  obj.buildLevel = 50
  obj.improvementPerPlayerLevels = 5
)

PropertyType.define('hangar', (obj)->
  obj.transportTypeKey = 'air'

  obj.price = 10000
  obj.baseTransportsCount = 2
  obj.buildLevel = 50
  obj.improvementPerPlayerLevels = 5
)

PropertyType.define('railway_station', (obj)->
  obj.transportTypeKey = 'railway'

  obj.price = 10000
  obj.baseTransportsCount = 2
  obj.buildLevel = 50
  obj.improvementPerPlayerLevels = 5
)

