TransportType = require('../game_data').TransportType

TransportType.define('auto', (obj)->
  obj.subTypes = ['truck', 'tractor', 'trailer', 'semitrailer']
  obj.level = 1
  obj.propertyTypeKey = 'garage'
)

TransportType.define('railway', (obj)->
  obj.level = 5
  obj.propertyTypeKey = 'train_depot'
)
TransportType.define('air', (obj)->
  obj.level = 15
  obj.propertyTypeKey = 'hangar'
)
TransportType.define('sea', (obj)->
  obj.level = 25
  obj.propertyTypeKey = 'sea_port'
)