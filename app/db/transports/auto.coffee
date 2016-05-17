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