_ = require("lodash")
Base = require("./base")

class PropertyType extends Base
  @configure(publicForClient: true)

#  price: null # цена за строительство и улучшение
#  transportTypeKey: null # вид транспорта какой содержит
#  employeeTypeKey: null # какой вид сотрудника содержит
#  baseTransportsCount: null # базовая вместительность траспорта
#  baseCargoCount: null # базовое кол-во грузоперевозок для склада
#  buildLevel: null # уровень на котором будет разрешено построить здание
#  improvementPerPlayerLevels: null # через сколько уровней игрока будет разрешено улучшать на один уровень

  basicPrice: null
  buildLevel: null
  buildDuration: null

  constructor: ->
    super

    @basicPrice = null
    @buildLevel = null
    @buildDuration = null

#validationForDefine: ->

  toJSON: ->
    _.assign(
      basicPrice: @basicPrice
      buildLevel: @buildLevel
      buildDuration: @buildDuration
      ,
      super
    )




module.exports = PropertyType