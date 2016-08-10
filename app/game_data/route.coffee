_ = require("lodash")
Base = require("./base")

class Route extends Base
  tag: null
  goodKey: null
  distance: null
  weight: null # тонны
  reputation: null # требуемая репутация для выолнения

  @configure(publicForClient: true)

  constructor: ->
    super

    @tag = null
    @goodKey = null
    @distance = null
    @weight = null
    @reputation = null

  validationForDefine: ->
    throw new Error('undefined tag') unless @tag?
    throw new Error('undefined goodKey') unless @goodKey?
    throw new Error('undefined distance') unless @distance?
    throw new Error('undefined weight') unless @weight?
    throw new Error('undefined reputation') unless @reputation?

  toJSON: ->
    _.assign(
      reward: @reward
      requirement: @requirement
      tag: @tag
      goodKey: @goodKey
      distance: @distance
      weight: @weight
      reputation: @reputation
      ,
      super
    )

module.exports = Route