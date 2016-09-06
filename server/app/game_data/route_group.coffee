_ = require("lodash")
Base = require("./base")

class RouteGroup extends Base
  @configure(publicForClient: true)

  constructor: ->
    super

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

  validationForDefine: ->

  toJSON: ->
    _.assign(
      requirement: @requirement
      ,
      super
    )

module.exports = RouteGroup