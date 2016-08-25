require('../transport_groups')

TransportModel = require('../../game_data').TransportModel
Good = require('../../game_data').Good

group = 'truck'

TransportModel.define('van', (obj)->
  obj.transportGroupKey = group
  obj.level = 1
  obj.consumption = 7
  obj.reliability = 74
  obj.carrying = 0.5
  obj.travelSpeed = 70
  obj.isPrimary = true
  obj.basicPrice = 100
)

TransportModel.define('van_fugo', (obj)->
  obj.transportGroupKey = group
  obj.level = 1
  obj.consumption = 8
  obj.reliability = 76
  obj.carrying = 0.5
  obj.travelSpeed = 73
  obj.isPrimary = true
  obj.basicPrice = 150
)

TransportModel.define('van_hask', (obj)->
  obj.transportGroupKey = group
  obj.level = 2
  obj.consumption = 8
  obj.reliability = 79
  obj.carrying = 0.5
  obj.travelSpeed = 80
  obj.isPrimary = true
  obj.basicPrice = 200
)

TransportModel.define('van_pup', (obj)->
  obj.transportGroupKey = group
  obj.level = 2
  obj.consumption = 8
  obj.reliability = 79
  obj.carrying = 0.5
  obj.travelSpeed = 80
  obj.isPrimary = true
  obj.basicPrice = 200
)

