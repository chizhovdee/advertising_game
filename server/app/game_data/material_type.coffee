_ = require("lodash")
Base = require("./base")

class MaterialType extends Base
  @configure publicForClient: true

  townLevel: null # ресурс доступный для продажи в городе

  constructor: ->
    super

    @townLevel = 1

  validateOnDefine: ->
    throw new Error('undefined @townLevel') unless @townLevel?

  toJSON: ->
    _.assign(
      townLevel: @townLevel
      ,
      super
    )

module.exports = MaterialType