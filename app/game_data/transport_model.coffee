_ = require("lodash")
Base = require("./base")
TransportGroup = require('./transport_group')

class TransportModel extends Base
  transportGroupKey: null
  level: null
  consumption: null # расход топлива на 100 км
  reliability: null # надежность - процент на 10 000 км
  carrying: null # грузоподъемность тонны
  travelSpeed: null # средняя скорость перемещения
  basicPrice: null
  goodKeys: null
  isPrimary: false # параметр для обозначения тягача, тепловозов, всего что само приводится в движение

  @configure(publicForClient: true)

  @afterDefine 'setGroup'

  constructor: ->
    super

    @transportGroupKey = null
    @level = null
    @consumption = null
    @reliability = null
    @carrying = null
    @travelSpeed = null
    @goodKeys = []
    @isPrimary = false
    @basicPrice = null

  setGroup: ->
    Object.defineProperty(@, 'group'
      value: TransportGroup.find(@transportGroupKey)
      writable: false
      enumerable: true
    )

    @type.addTransportModel(@)

  validationForDefine: ->
    throw new Error('undefined typeKey') unless @transportGroupKey?
    throw new Error('undefined level') unless @level?
    throw new Error('undefined consumption') unless @consumption?
    throw new Error('undefined reliability') unless @reliability?
    throw new Error('undefined travel speed') unless @travelSpeed?
    throw new Error('undefined basic price') unless @basicPrice?

  toJSON: ->
    _.assign(
      level: @level
      consumption: @consumption
      reliability: @reliability
      carrying: @carrying
      travelSpeed: @travelSpeed
      transportGroupKey: @transportGroupKey
      goodKeys: @goodKeys
      isPrimary: @isPrimary
      basicPrice: @basicPrice
      ,
      super
    )

module.exports = TransportModel