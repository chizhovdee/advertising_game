_ = require("lodash")
Base = require("./base")
RouteType = require('./route_type')

class Route extends Base
  tag: null
  goodKey: null
  distance: null
  weight: null # тонны
  reputation: null # требуемая репутация для выолнения

  @configure(publicForClient: true)

  @afterDefine 'setType'

  constructor: ->
    super

    @tag = null
    @goodKey = null
    @distance = null
    @weight = null
    @reputation = null

  setType: ->
    Object.defineProperty(@, 'type'
      value: RouteType.find(@typeKey)
      writable: false
      enumerable: true
    )

    @type.addRoute(@)

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