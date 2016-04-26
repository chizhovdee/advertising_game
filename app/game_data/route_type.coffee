_ = require("lodash")
Base = require("./base")

class RouteType extends Base
  @configure()

  constructor: ->
    super

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
  # empty

module.exports = RouteType