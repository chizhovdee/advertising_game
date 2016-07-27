_ = require("lodash")
Base = require("./base")

class PropertyType extends Base
  @configure(publicForClient: true)

  @rentOutDuration: _(1).days()

  basicPrice: null # базовая цена за строительство и за улучшение
  buildLevel: null # уровень требуемый для строительства
  buildDuration: null # время строительства
  baseCapacity: null # базовая вместительность ресурсов (чего именно, зависит от контекста)
  freeCapacity: null # свободная вместительность
  upgradePerLevels: null # через сколько уровней игрока будет разрешено улучшать на один уровень, начиная с buildLevel
  upgradeDuration: null # время улучшения
  rentOutAvailable: null # можно ли сдать в аренду

  constructor: ->
    super

    @basicPrice = null
    @buildLevel = null
    @buildDuration = null
    @baseCapacity = null
    @freeCapacity = null
    @upgradePerLevels = null
    @baseUpgradeDuration = null
    @rentOutAvailable = false

  validationForDefine: ->
    throw new Error('undefined @basicPrice') unless @basicPrice?
    throw new Error('undefined @buildLevel') unless @buildLevel?
    throw new Error('undefined @buildDuration') unless @buildDuration?
    throw new Error('undefined @baseCapacity') unless @baseCapacity?
    throw new Error('undefined @freeCapacity') unless @freeCapacity?
    throw new Error('undefined @upgradePerLevels') unless @upgradePerLevels?
    throw new Error('undefined @baseUpgradeDuration') unless @baseUpgradeDuration?


  upgradeLevelBy: (propertyLevel)->
    propertyLevel * @upgradePerLevels - (@buildLevel - 1)

  upgradePriceBy: (propertyLevel)->
    (propertyLevel + 1) * @basicPrice

  upgradeDurationBy: (propertyLevel)->
    propertyLevel * @baseUpgradeDuration

  fullCapacityBy: (property)->
    @.capacityByLevel(property?.level || 0) + @freeCapacity

  capacityByLevel: (level)->
    @baseCapacity * level

  toJSON: ->
    _.assign(
      basicPrice: @basicPrice
      buildLevel: @buildLevel
      buildDuration: @buildDuration
      baseCapacity: @baseCapacity
      freeCapacity: @freeCapacity
      upgradePerLevels: @upgradePerLevels
      baseUpgradeDuration: @baseUpgradeDuration
      rentOutAvailable: @rentOutAvailable
      reward: @reward
      ,
      super
    )


module.exports = PropertyType