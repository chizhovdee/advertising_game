_ = require("lodash")
Base = require("./base")

class MaterialType extends Base
  @configure publicForClient: true

  townLevel: null # ресурс доступный для продажи в городе
  sellBasicPrice: null

  constructor: ->
    super

    @townLevel = 1

  validateOnDefine: ->
    throw new Error('undefined @townLevel') unless @townLevel?
    throw new Error('undefined @sellBasicPrice') unless @sellBasicPrice?

  toJSON: ->
    _.assign(
      townLevel: @townLevel
      sellBasicPrice: @sellBasicPrice
      ,
      super
    )

module.exports = MaterialType