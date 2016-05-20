AdvertisingType = require('../game_data').AdvertisingType

AdvertisingType.define('newspaper', (obj)->
  obj.level = 1
  obj.basicPrice = 5
)

AdvertisingType.define('radio', (obj)->
  obj.level = 10
  obj.basicPrice = 10
)

AdvertisingType.define('tv', (obj)->
  obj.level = 20
  obj.basicPrice = 15
)

AdvertisingType.define('internet', (obj)->
  obj.level = 30
  obj.basicPrice = 20
)