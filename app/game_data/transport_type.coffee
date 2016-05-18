_ = require("lodash")
Base = require("./base")

class TransportType extends Base
  @configure(publicForClient: true)

  constructor: ->
    super

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

module.exports = TransportType