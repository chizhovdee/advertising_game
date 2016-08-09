_ = require('lodash')

AdvertisingType = require('../game_data').AdvertisingType

AdvertisingType.define('newspaper', (obj)->
  obj.basicPrice = 50
  obj.timeGeneration = _(0.2).minutes()
)

AdvertisingType.define('radio', (obj)->
  obj.basicPrice = 150
  obj.timeGeneration = _(0.2).minutes()
)

AdvertisingType.define('tv', (obj)->
  obj.basicPrice = 300
  obj.timeGeneration = _(0.2).minutes()
)

AdvertisingType.define('internet', (obj)->
  obj.basicPrice = 500
  obj.timeGeneration = _(0.2).minutes()
)