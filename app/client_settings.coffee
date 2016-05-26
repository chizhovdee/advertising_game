gameData = require('./game_data')
AdvertisingType = gameData.AdvertisingType

module.exports =
  advertisingType:
    periods: AdvertisingType.periods
    status: AdvertisingType.status
    discountPerDay: AdvertisingType.discountPerDay
    statusFactor: AdvertisingType.statusFactor