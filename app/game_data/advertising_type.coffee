_ = require("lodash")
Base = require("./base")

class AdvertisingType extends Base
  @periods: [1..7] # days

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

module.exports = AdvertisingType