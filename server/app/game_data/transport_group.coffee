_ = require("lodash")
Base = require("./base")

class TransportGroup extends Base
  @configure(publicForClient: true)

  level: null

  constructor: ->
    super

    @level = null

    Object.defineProperties(@,
      _transportModels: {
        value: []
        writable: false
      }
      transportModels: {
        enumerable: true
        get: -> @_transportModels
      }
    )

  addTransportModel: (transport)->
    _.addUniq(@_transportModels, transport)

  validateOnDefine: ->
    throw new Error('undefined level') unless @level?

  toJSON: ->
    _.assign(
      level: @level
      ,
      super
    )

module.exports = TransportGroup