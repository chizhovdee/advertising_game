_ = require("lodash")
Base = require("./base")

class TransportType extends Base
  @configure(publicForClient: true)

  subTypes: null
  level: null
  propertyTypeKey: null # ключ property для размещения транспорта

  constructor: ->
    super

    @subTypes = []
    @level = null
    @propertyTypeKey = null

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
    throw new Error('undefined propertyTypeKey') unless @propertyTypeKey?

  toJSON: ->
    _.assign(
      subTypes: @subTypes
      level: @level
      propertyTypeKey: @propertyTypeKey
      ,
      super
    )

module.exports = TransportType