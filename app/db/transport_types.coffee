TransportType = require('../game_data').TransportType

TransportType.define('auto', (obj)->
  obj.subTypes = ['truck', 'tractor', 'trailer', 'semitrailer']
)

TransportType.define('railway')
TransportType.define('air')
TransportType.define('sea')