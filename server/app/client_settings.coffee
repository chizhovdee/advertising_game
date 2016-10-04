gameData = require('./game_data')
models = require('./models')
balance = require('./lib').balance

Player = models.Player
AdvertisingType = gameData.AdvertisingType
PropertyType = gameData.PropertyType
TownLevel = gameData.TownLevel

module.exports =
  player:
    stateFields: Player.stateFields

  balanceSettings: balance.settings

  advertisingType:
    periods: AdvertisingType.periods
    status: AdvertisingType.status
    discountPerDay: AdvertisingType.discountPerDay
    statusFactor: AdvertisingType.statusFactor
    statusLevels: AdvertisingType.statusLevels
    maxDuration: AdvertisingType.maxDuration

  townLevel:
    bonusDuration: TownLevel.bonusDuration
    bonusBasicMoney: TownLevel.bonusBasicMoney
    bonusFactor: TownLevel.bonusFactor
    basicMaterialLimit: TownLevel.basicMaterialLimit
    materialLimitFactor: TownLevel.materialLimitFactor



