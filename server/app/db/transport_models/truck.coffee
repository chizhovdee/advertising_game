require('../transport_groups')

TransportModel = require('../../game_data').TransportModel

group = 'truck'

TransportModel.define('van', (obj)->
  obj.transportGroupKey = group
  obj.level = 1
  obj.reliability = 74
  obj.carrying = 500
  obj.travelSpeed = 70
  obj.isPrimary = true
  obj.basicPrice = 100
  obj.materials = ['coal']
)

TransportModel.define('van_fugo', (obj)->
  obj.transportGroupKey = group
  obj.level = 1
  obj.reliability = 76
  obj.carrying = 550
  obj.travelSpeed = 73
  obj.isPrimary = true
  obj.basicPrice = 150
  obj.materials = ['coal', 'iron_ore']
)

TransportModel.define('van_hask', (obj)->
  obj.transportGroupKey = group
  obj.level = 2
  obj.consumption = 8
  obj.reliability = 79
  obj.carrying = 600
  obj.travelSpeed = 80
  obj.isPrimary = true
  obj.basicPrice = 200
  obj.materials = ['wood']
)

TransportModel.define('van_pup', (obj)->
  obj.transportGroupKey = group
  obj.level = 2
  obj.reliability = 79
  obj.carrying = 600
  obj.travelSpeed = 85
  obj.isPrimary = true
  obj.basicPrice = 200
  obj.materials = ['iron_ore']
)

