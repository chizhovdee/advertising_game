_ = require("lodash")
Base = require("./base")

class PropertyType extends Base
  @configure()

  price: null # цена за строительство и улучшение
  transportTypeKey: null
  baseTransportsCount: null # базовая вместительность траспорта
  baseCargoCount: null # базовое кол-во грузоперевозок для склада
  buildLevel: null # уровень на котором будет разрешено построить здание
  improvementPerPlayerLevels: null # через сколько уровней игрока будет разрешено улучшать на один уровень

  constructor: ->
    super

    @price = null
    @transportTypeKey = null
    @baseTransportsCount = null
    @baseCargoCount = null
    @buildLevel = null
    @improvementPerPlayerLevels = null

  #validationForDefine: ->



module.exports = PropertyType