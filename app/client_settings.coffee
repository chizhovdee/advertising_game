gameData = require('./game_data')
models = require('./models')
balance = require('./lib').balance

Player = models.Player
AdvertisingType = gameData.AdvertisingType
PropertyType = gameData.PropertyType

module.exports =
  player:
    stateFields: Player.stateFields

  balanceSettings: balance.settings

  advertisingType:
    periods: AdvertisingType.periods
    status: AdvertisingType.status
    discountPerDay: AdvertisingType.discountPerDay
    statusFactor: AdvertisingType.statusFactor

  propertyType:
    rentOutDuration: PropertyType.rentOutDuration