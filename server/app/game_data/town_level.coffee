_ = require("lodash")
Base = require("./base")

class TownLevel extends Base
  @configure(publicForClient: true)

  @bonusBasicMoney: 100 # базовый бонус, будет умножаться на уровень
  @bonusDuration: _(24).hours()
  @bonusFactor: 0.2 # коэффициент для подсчета бонуса за каждый уровень

  @basicMaterialLimit: 100 # начальный лимит материала доставляемого в город в сутки
  @materialLimitFactor: 0.5 # коэффициент для подсчета лимита за каждый уровень

  number: null # level
  materials: null # материалы для улучшения

  @findByNumber: (number)->
    @.findByAttributes(number: number)

  constructor: ->
    super

    @number = null
    @materials = {}

  addMaterial: (material, value)->
    throw new Error("material #{material} is added") if @.isContainMaterial()

    @materials[material] = value

  isContainMaterial: (materialTypeKey)->
    @materials[materialTypeKey]?

  validateOnDefine: ->
    throw new Error('undefined number') unless @number?

  toJSON: ->
    _.assign(
      number: @number
      materials: @materials
      ,
      super
    )

module.exports = TownLevel