_ = require("lodash")
Base = require("./base")

class MaterialType extends Base
  @configure publicForClient: true

  level: null

  constructor: ->
    super

    @level = 1

  validationForDefine: ->
    throw new Error('undefined @level') unless @level?

  toJSON: ->
    _.assign(
      level: @level
      ,
      super
    )


module.exports = MaterialType