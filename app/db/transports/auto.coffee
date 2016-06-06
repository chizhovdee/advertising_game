require('../transport_types')

Transport = require('../../game_data').Transport

Transport.define('van', (obj)->
  obj.typeKey = 'auto'

  obj.consumption = 7
  obj.reliability = 74
  obj.carrying = 0.5
  obj.travelSpeed = 70

  obj.goodTypeKeys = ['everyday', 'industrial']

  obj.isPrimary = true
)

Transport.define('van_fugo', (obj)->
  obj.typeKey = 'auto'

  obj.consumption = 8
  obj.reliability = 76
  obj.carrying = 0.5
  obj.travelSpeed = 73

  obj.goodTypeKeys = ['everyday', 'industrial']

  obj.isPrimary = true
)

Transport.define('van_hask', (obj)->
  obj.typeKey = 'auto'

  obj.consumption = 8
  obj.reliability = 79
  obj.carrying = 0.5
  obj.travelSpeed = 80

  obj.goodTypeKeys = ['everyday', 'industrial']

  obj.isPrimary = true
)


