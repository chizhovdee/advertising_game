TransportGroup = require('../game_data').TransportGroup

TransportGroup.define('truck', (obj)->
  obj.level = 1
)

TransportGroup.define('tractor', (obj)->
  obj.level = 2
)

TransportGroup.define('trailer', (obj)->
  obj.level = 3
)

TransportGroup.define('semitrailer', (obj)->
  obj.level = 4
)