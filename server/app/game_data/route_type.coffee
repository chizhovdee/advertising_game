_ = require("lodash")
Base = require("./base")

RouteGroup = require('./route_group')

class RouteType extends Base
  routeGroupKey: null
  materialKey: null
  distance: null
  weight: null # вес

  @configure(publicForClient: true)

  @afterDefine 'setRouteGroup'

  constructor: ->
    super

    @routeGroupKey = null
    @materialKey = null
    @distance = null
    @weight = null

  setRouteGroup: ->
    Object.defineProperty(@, 'routeGroup'
      value: RouteGroup.find(@routeGroupKey)
      writable: false
      enumerable: true
    )

    @routeGroup.addRouteType(@)

  validationForDefine: ->
    throw new Error('undefined goodKey') unless @materialKey?
    throw new Error('undefined distance') unless @distance?
    throw new Error('undefined weight') unless @weight?

  toJSON: ->
    _.assign(
      routeGroupKey: @routeGroupKey
      reward: @reward
      requirement: @requirement
      materialKey: @materialKey
      distance: @distance
      weight: @weight
      ,
      super
    )

module.exports = RouteType