require('../transport_types')

type = 'auto'
subType = 'tractor'

Transport = require('../../game_data').Transport

Transport.define('tractor_1', (obj)->
  obj.typeKey = type
  obj.level = 2
  obj.subType = subType
  obj.consumption = 7
  obj.reliability = 74
  obj.carrying = 0
  obj.travelSpeed = 70
  obj.goodTypeKeys = ['any']
  obj.isPrimary = true
  obj.basicPrice = 1500
)

Transport.define('tractor_2', (obj)->
  obj.typeKey = type
  obj.level = 3
  obj.subType = subType
  obj.consumption = 8
  obj.reliability = 76
  obj.carrying = 0
  obj.travelSpeed = 73
  obj.goodTypeKeys = ['any']
  obj.isPrimary = true
  obj.basicPrice = 2500
)
