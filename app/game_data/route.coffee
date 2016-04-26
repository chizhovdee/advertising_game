_ = require("lodash")
Base = require("./base")
RouteType = require('./route_type')

class Route extends Base
  typeKey: null

  @configure()

  @afterDefine 'setType'

  constructor: ->
    super

    @food = false

  setType: ->
    Object.defineProperty(@, 'type'
      value: RouteType.find(@typeKey)
      writable: false
      enumerable: true
    )

    @type.addRoute(@)

  validationForDefine: ->
    return new Error('undefined typeKey') unless @typeKey?


module.exports = Route