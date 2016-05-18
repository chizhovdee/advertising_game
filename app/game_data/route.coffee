_ = require("lodash")
Base = require("./base")
RouteType = require('./route_type')

class Route extends Base
  typeKey: null
  goodKey: null
  goodTypeKey: null
  distance: null
  weight: null # тонны

  @configure(publicForClient: true)

  @afterDefine 'setType'

  constructor: ->
    super

    @typeKey = null
    @goodKey = null
    @goodTypeKey = null
    @distance = null
    @weight = null

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

  toJSON: ->
    _.assign(
      reward: @reward
      requirement: @requirement
      typeKey: @typeKey
      goodKey: @goodKey
      goodTypeKey: @goodTypeKey
      distance: @distance
      weight: @weight
      ,
      super
    )

module.exports = Route