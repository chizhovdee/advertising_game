_ = require("lodash")
Base = require("./base")

class Advertising extends Base
  level: null
  basicPrice: null

  @configure(publicForClient: true)

  constructor: ->
    super

    @level = null
    @basicPrice = null

  toJSON: ->
    _.assign(
      level: @level
      basicPrice: @basicPrice
      ,
      super
    )

module.exports = Advertising