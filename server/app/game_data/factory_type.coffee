_ = require("lodash")
Base = require("./base")

class FactoryType extends Base
  @configure publicForClient: true

  @productionNumbers: [0...6]

  basicPrice: null # базовая цена за строительство и за улучшение
  buildLevel: null # уровень требуемый для строительства
  buildDuration: null # время строительства
  upgradePerLevels: null # через сколько уровней игрока будет разрешено улучшать на один уровень, начиная с buildLevel
  upgradeDuration: null # время улучшения
  productions: null # хранится различное время производства

  constructor: ->
    super

    @productions = {}

    @basicPrice = null
    @buildLevel = null
    @buildDuration = null
    @upgradePerLevels = null
    @baseUpgradeDuration = null

  validationForDefine: ->
    throw new Error('undefined @basicPrice') unless @basicPrice?
    throw new Error('undefined @buildLevel') unless @buildLevel?
    throw new Error('undefined @buildDuration') unless @buildDuration?
    throw new Error('undefined @upgradePerLevels') unless @upgradePerLevels?
    throw new Error('undefined @baseUpgradeDuration') unless @baseUpgradeDuration?

  upgradeLevelBy: (factoryLevel)->
    factoryLevel * @upgradePerLevels - (@buildLevel - 1)

  upgradePriceBy: (factoryLevel)->
    (factoryLevel + 1) * @basicPrice

  upgradeDurationBy: (factoryLevel)->
    factoryLevel * @baseUpgradeDuration

  addRewardForProduction: (number, callback)->
    @.addReward("collectProduction#{ number }", callback)

  addRequirementForProduction: (number, callback)->
    @.addRequirement("startProduction#{ number }", callback)

  toJSON: ->
    _.assign(
      basicPrice: @basicPrice
      buildLevel: @buildLevel
      buildDuration: @buildDuration
      upgradePerLevels: @upgradePerLevels
      baseUpgradeDuration: @baseUpgradeDuration
      reward: @reward
      requirement: @requirement
      productions: @productions
      ,
      super
    )


module.exports = FactoryType