_ = require("lodash")
Base = require("./base")

class TransportType extends Base
  @configure(publicForClient: true)

  subTypes: null

  constructor: ->
    super

    @subTypes = []

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
   # empty

  toJSON: ->
    _.assign(
      subTypes: @subTypes
      ,
      super
    )

module.exports = TransportType