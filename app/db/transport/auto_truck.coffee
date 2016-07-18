require('../transport_types')

type = 'auto'
subType = 'truck'

Transport = require('../../game_data').Transport

Transport.define('van', (obj)->
  obj.typeKey = type
  obj.subType = subType
  obj.consumption = 7
  obj.reliability = 74
  obj.carrying = 0.5
  obj.travelSpeed = 70
  obj.goodTypeKeys = ['everyday']
  obj.isPrimary = true
  obj.basicPrice = 100
)

Transport.define('van_fugo', (obj)->
  obj.typeKey = type
  obj.subType = subType
  obj.consumption = 8
  obj.reliability = 76
  obj.carrying = 0.5
  obj.travelSpeed = 73
  obj.goodTypeKeys = ['industrial']
  obj.isPrimary = true
  obj.basicPrice = 150
)

Transport.define('van_hask', (obj)->
  obj.typeKey = type
  obj.subType = subType
  obj.consumption = 8
  obj.reliability = 79
  obj.carrying = 0.5
  obj.travelSpeed = 80
  obj.goodTypeKeys = ['everyday', 'industrial']
  obj.isPrimary = true
  obj.basicPrice = 200
)

Transport.define('van_pup', (obj)->
  obj.typeKey = type
  obj.subType = subType
  obj.consumption = 8
  obj.reliability = 79
  obj.carrying = 0.5
  obj.travelSpeed = 80
  obj.goodTypeKeys = ['everyday', 'industrial']
  obj.isPrimary = true
  obj.basicPrice = 200
)

