_ = require("lodash")
Base = require("./base")

class RouteType extends Base
  level: null

  @configure(publicForClient: true)

  constructor: ->
    super

    @level = null

    Object.defineProperties(@,
      _routes: {
        value: []
        writable: false
      }
      routes: {
        enumerable: true
        get: -> @_routes
      }
    )

  addRoute: (route)->
    _.addUniq(@_routes, route)

  validationForDefine: ->
    throw new Error("undefined level") unless @level?

  toJSON: ->
    _.assign(
      level: @level
      ,
      super
    )

module.exports = RouteType