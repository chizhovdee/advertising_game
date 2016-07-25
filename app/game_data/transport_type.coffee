_ = require("lodash")
Base = require("./base")

class TransportType extends Base
  @configure(publicForClient: true)

  subTypes: null
  level: null

  constructor: ->
    super

    @subTypes = []
    @level = null

    Object.defineProperties(@,
      _transports: {
        value: []
        writable: false
      }
      transports: {
        enumerable: true
        get: -> @_transports
      }
    )

  addTransport: (transport)->
    _.addUniq(@_transports, transport)

  validationForDefine: ->
    throw new Error('undefined level') unless @level?

  toJSON: ->
    _.assign(
      subTypes: @subTypes
      level: @level
      ,
      super
    )

module.exports = TransportType