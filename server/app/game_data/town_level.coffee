_ = require("lodash")
Base = require("./base")

class TownLevel extends Base
  @configure(publicForClient: true)

  @bonusBasicMoney: 100 # базовый бонус, будет умножаться на уровень
  @bonusDuration: _(24).hours()
  @bonusFactor: 0.2 # коэффициент для подсчета бонуса за каждый уровень

  number: null # level
  materials: null # материалы для улучшения

  constructor: ->
    super

    @number = null
    @materials = {}

  addMaterial: (material, value)->
    throw new Error("material #{material} is added") if @materials[material]?

    @materials[material] = value

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