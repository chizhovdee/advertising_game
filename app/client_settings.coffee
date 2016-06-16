gameData = require('./game_data')
models = require('./models')

Player = models.Player
AdvertisingType = gameData.AdvertisingType

module.exports =
  player:
    stateFields: Player.stateFields
    balance: Player.balance

  advertisingType:
    periods: AdvertisingType.periods
    status: AdvertisingType.status
    discountPerDay: AdvertisingType.discountPerDay
    statusFactor: AdvertisingType.statusFactor