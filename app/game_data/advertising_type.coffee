_ = require("lodash")
Base = require("./base")

class AdvertisingType extends Base
  @periods: [1..7] # days
  @status: ['normal', 'vip', 'premium']
  @discountPerDay: 0.05 # 5%
  @statusFactor:
    normal: 1
    vip: 2
    premium: 3

  level: null
  basicPrice: null
  timeGeneration: null

  @configure(publicForClient: true)

  constructor: ->
    super

    @basicPrice = null
    @timeGeneration = null

  toJSON: ->
    _.assign(
      basicPrice: @basicPrice
      timeGeneration: @timeGeneration
      ,
      super
    )

module.exports = AdvertisingType