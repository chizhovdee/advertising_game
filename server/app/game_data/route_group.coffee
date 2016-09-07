_ = require("lodash")
Base = require("./base")

class RouteGroup extends Base
  @configure(publicForClient: true)

  level: null

  constructor: ->
    super

    @level = null

    Object.defineProperties(@,
      _routeTypes: {
        value: []
        writable: false
      }
      routeTypes: {
        enumerable: true
        get: -> @_routeTypes
      }
    )

  addRouteType: (routeType)->
    _.addUniq(@_routeTypes, routeType)

  validateOnDefine: ->
    throw new Error('undefined level') unless @level?

  toJSON: ->
    _.assign(
      level: @level
      ,
      super
    )

module.exports = RouteGroup