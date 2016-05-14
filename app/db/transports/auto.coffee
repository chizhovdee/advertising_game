require('../transport_types')

Transport = require('../../game_data').Transport

Transport.define('small_truck_1', (obj)->
  obj.typeKey = 'auto'

  obj.consumption = 15
  obj.reliability = 84
  obj.carrying = 500
  obj.travelSpeed = 60

  obj.goodTypeKeys = ['industrial']

  obj.isPrimary = true
)

Transport.define('small_truck_2', (obj)->
  obj.typeKey = 'auto'

  obj.consumption = 15
  obj.reliability = 84
  obj.carrying = 500
  obj.travelSpeed = 60

  obj.goodTypeKeys = ['clothes']

  obj.isPrimary = true
)

Transport.define('small_truck_3', (obj)->
  obj.typeKey = 'auto'

  obj.consumption = 15
  obj.reliability = 84
  obj.carrying = 500
  obj.travelSpeed = 60

  obj.goodTypeKeys = ['food']

  obj.isPrimary = true
)

Transport.define('tyagach_kamaz', (obj)->
  obj.typeKey = 'auto'

  obj.consumption = 15
  obj.reliability = 84
  obj.carrying = 0
  obj.travelSpeed = 80

  obj.goodTypeKeys = ['any']

  obj.isPrimary = true
)

Transport.define('grunwald', (obj)->
  obj.typeKey = 'auto'

  obj.consumption = 15
  obj.reliability = 84
  obj.carrying = 1000
  obj.travelSpeed = 0

  obj.goodTypeKeys = ['industrial']
)