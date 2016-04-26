_ = require("lodash")
Base = require("./base")
TransportType = require('./transport_type')

class Transport extends Base
  typeKey: null

  consumption: null # расход топлива на 100 км
  reliability: null # надежность - процент на 10 000 км
  carrying: null # грузоподъемность кг

  # тип груза / груз
  goodTypeKeys: null
  goodKeys: null

  isPrimary: false # параметр для обозначения тягача, тепловозов, всего что само приводится в движение

  @configure()

  @afterDefine 'setType'

  constructor: ->
    super

    @typeKey = null

    @consumption = null
    @reliability = null
    @carrying = null

    @goodTypeKeys = []
    @goodKeys = []

    @isPrimary = false

  setType: ->
    Object.defineProperty(@, 'type'
      value: TransportType.find(@typeKey)
      writable: false
      enumerable: true
    )

    @type.addTransport(@)

  validationForDefine: ->
    throw new Error('undefined typeKey') unless @typeKey?
    throw new Error('undefined consumption') unless @consumption?
    throw new Error('undefined reliability') unless @reliability?
    throw new Error('empty goodTypeKeys or goodKeys') if @goodKeys.length == 0 && @goodTypeKeys.length == 0

module.exports = Transport