_ = require("lodash")
Base = require("./base")

class FactoryType extends Base
  @configure publicForClient: true

  @durationsCount: 6

  basicPrice: null # базовая цена за строительство и за улучшение
  buildLevel: null # уровень требуемый для строительства
  buildDuration: null # время строительства
  upgradePerLevels: null # через сколько уровней игрока будет разрешено улучшать на один уровень, начиная с buildLevel
  upgradeDuration: null # время улучшения
  durations: null

  constructor: ->
    super

    @durations = {}

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

  addRewardForDuration: (durationNumber, callback)->
    @.addReward("collect_duration_#{ durationNumber }", callback)

  addRequirementForDuration: (durationNumber, callback)->
    @.addRequirement("start_duration_#{ durationNumber }", callback)

  toJSON: ->
    _.assign(
      basicPrice: @basicPrice
      buildLevel: @buildLevel
      buildDuration: @buildDuration
      upgradePerLevels: @upgradePerLevels
      baseUpgradeDuration: @baseUpgradeDuration
      reward: @reward
      requirement: @requirement
      durations: @durations
      ,
      super
    )


module.exports = FactoryType