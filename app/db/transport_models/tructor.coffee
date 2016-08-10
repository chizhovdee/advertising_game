require('../transport_groups')

group = 'tractor'

TransportModel = require('../../game_data').TransportModel

TransportModel.define('tractor_1', (obj)->
  obj.transportGroupKey = group
  obj.level = 2
  obj.consumption = 7
  obj.reliability = 74
  obj.carrying = 0
  obj.travelSpeed = 70
  obj.isPrimary = true
  obj.basicPrice = 1500
)

TransportModel.define('tractor_2', (obj)->
  obj.transportGroupKey = group
  obj.level = 3
  obj.consumption = 8
  obj.reliability = 76
  obj.carrying = 0
  obj.travelSpeed = 73
  obj.isPrimary = true
  obj.basicPrice = 2500
)
