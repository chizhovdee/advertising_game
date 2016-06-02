_ = require("lodash")
Base = require("./base")
RouteType = require('./route_type')

class Route extends Base
  typeKey: null
  goodKey: null
  goodTypeKey: null
  transportTypeKey: null
  distance: null
  weight: null # тонны
  reputation: null # требуемая репутация для выолнения

  @configure(publicForClient: true)

  @afterDefine 'setType'

  constructor: ->
    super

    @typeKey = null
    @goodKey = null
    @goodTypeKey = null
    @transportTypeKey = null
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
    throw new Error('undefined typeKey') unless @typeKey?
    throw new Error('undefined goodKey or goodTypeKey') if !@goodKey? && !@goodTypeKey?
    throw new Error('undefined distance') unless @distance?
    throw new Error('undefined weight') unless @weight?
    throw new Error('undefined transportTypeKey') unless @transportTypeKey?
    throw new Error('undefined reputation') unless @reputation?

  toJSON: ->
    _.assign(
      reward: @reward
      requirement: @requirement
      typeKey: @typeKey
      goodKey: @goodKey
      goodTypeKey: @goodTypeKey
      transportTypeKey: @transportTypeKey
      distance: @distance
      weight: @weight
      reputation: @reputation
      ,
      super
    )

module.exports = Route