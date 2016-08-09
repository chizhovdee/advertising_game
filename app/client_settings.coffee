gameData = require('./game_data')
models = require('./models')
balance = require('./lib').balance

Player = models.Player
AdvertisingType = gameData.AdvertisingType
PropertyType = gameData.PropertyType

module.exports =
  player:
    stateFields: Player.stateFields

  fuel: {
    types: Player.fuelTypes
    levels: Player.fuelLevels
  }

  balanceSettings: balance.settings

  advertisingType:
    periods: AdvertisingType.periods
    status: AdvertisingType.status
    discountPerDay: AdvertisingType.discountPerDay
    statusFactor: AdvertisingType.statusFactor
    statusLevels: AdvertisingType.statusLevels
    maxDuration: AdvertisingType.maxDuration

  propertyType:
    rentOutDuration: PropertyType.rentOutDuration