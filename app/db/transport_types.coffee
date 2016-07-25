TransportType = require('../game_data').TransportType

TransportType.define('auto', (obj)->
  obj.subTypes = ['truck', 'tractor', 'trailer', 'semitrailer']
  obj.level = 1
)

TransportType.define('railway', (obj)->
  obj.level = 5
)
TransportType.define('air', (obj)->
  obj.level = 15
)
TransportType.define('sea', (obj)->
  obj.level = 25
)