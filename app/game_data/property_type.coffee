_ = require("lodash")
Base = require("./base")

class PropertyType extends Base
  @configure(publicForClient: true)

  basicPrice: null # базовая цена за строительство и за улучшение
  buildLevel: null # уровень требуемый для строительства
  buildDuration: null # время строительства
  baseCapacity: null # базовая вместительность ресурсов (чего именно, зависит от контекста)
  upgradePerLevels: null # через сколько уровней игрока будет разрешено улучшать на один уровень, начиная с buildLevel
  upgradeDuration: null # время улучшения

  constructor: ->
    super

    @basicPrice = null
    @buildLevel = null
    @buildDuration = null
    @baseCapacity = null
    @upgradePerLevels = null
    @baseUpgradeDuration = null

  validationForDefine: ->
    throw new Error('undefined @basicPrice') unless @basicPrice?
    throw new Error('undefined @buildLevel') unless @buildLevel?
    throw new Error('undefined @buildDuration') unless @buildDuration?
    throw new Error('undefined @baseCapacity') unless @baseCapacity?
    throw new Error('undefined @upgradePerLevels') unless @upgradePerLevels?
    throw new Error('undefined @baseUpgradeDuration') unless @baseUpgradeDuration?

  upgradeLevelBy: (propertyLevel)->
    propertyLevel * @upgradePerLevels - (@buildLevel - 1)

  upgradePriceBy: (propertyLevel)->
    (propertyLevel + 1) * @basicPrice

  upgradeDurationBy: (propertyLevel)->
    propertyLevel * @baseUpgradeDuration

  toJSON: ->
    _.assign(
      basicPrice: @basicPrice
      buildLevel: @buildLevel
      buildDuration: @buildDuration
      baseCapacity: @baseCapacity
      upgradePerLevels: @upgradePerLevels
      baseUpgradeDuration: @baseUpgradeDuration
      ,
      super
    )


module.exports = PropertyType