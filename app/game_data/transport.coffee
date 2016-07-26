_ = require("lodash")
Base = require("./base")
TransportType = require('./transport_type')

class Transport extends Base
  typeKey: null

  level: null

  consumption: null # расход топлива на 100 км
  reliability: null # надежность - процент на 10 000 км
  carrying: null # грузоподъемность тонны
  travelSpeed: null # средняя скорость перемещения
  basicPrice: null

  # тип груза / груз
  goodTypeKeys: null
  goodKeys: null

  isPrimary: false # параметр для обозначения тягача, тепловозов, всего что само приводится в движение
  subType: null # подтип. Чисто для визуального различия

  @configure(publicForClient: true)

  @afterDefine 'setType'

  constructor: ->
    super

    @typeKey = null

    @level = null

    @consumption = null
    @reliability = null
    @carrying = null
    @travelSpeed = null

    @goodTypeKeys = []
    @goodKeys = []

    @isPrimary = false
    @basicPrice = null
    @subType = null

  setType: ->
    Object.defineProperty(@, 'type'
      value: TransportType.find(@typeKey)
      writable: false
      enumerable: true
    )

    @type.addTransport(@)

  validationForDefine: ->
    throw new Error('undefined typeKey') unless @typeKey?

    throw new Error('undefined level') unless @level?

    throw new Error('undefined consumption') unless @consumption?
    throw new Error('undefined reliability') unless @reliability?
    throw new Error('undefined travel speed') unless @travelSpeed?

    throw new Error('undefined basic price') unless @basicPrice?

    throw new Error('empty goodTypeKeys or goodKeys') if @goodKeys.length == 0 && @goodTypeKeys.length == 0

  toJSON: ->
    _.assign(
      level: @level
      consumption: @consumption
      reliability: @reliability
      carrying: @carrying
      travelSpeed: @travelSpeed
      typeKey: @typeKey
      goodKeys: @goodKeys
      goodTypeKeys: @goodTypeKeys
      isPrimary: @isPrimary
      basicPrice: @basicPrice
      subType: @subType
      ,
      super
    )

module.exports = Transport