_ = require("lodash")
Base = require("./base")
TransportGroup = require('./transport_group')

class TransportModel extends Base
  transportGroupKey: null
  level: null
  reliability: null # надежность - процент на 10 000 км
  carrying: null # грузоподъемность тонны
  travelSpeed: null # средняя скорость перемещения
  basicPrice: null
  isPrimary: false # параметр для обозначения тягача, тепловозов, всего что само приводится в движение
  materials: null

  @configure(publicForClient: true)

  @afterDefine 'setTransportGroup'

  constructor: ->
    super

    @transportGroupKey = null
    @level = null
    @reliability = null
    @carrying = null
    @travelSpeed = null
    @isPrimary = false
    @basicPrice = null
    @materials = []

  setTransportGroup: ->
    Object.defineProperty(@, 'transportGroup'
      value: TransportGroup.find(@transportGroupKey)
      writable: false
      enumerable: true
    )

    @transportGroup.addTransportModel(@)

  validateOnDefine: ->
    throw new Error('undefined typeKey') unless @transportGroupKey?
    throw new Error('undefined level') unless @level?
    throw new Error('undefined reliability') unless @reliability?
    throw new Error('undefined travel speed') unless @travelSpeed?
    throw new Error('undefined basic price') unless @basicPrice?

  toJSON: ->
    _.assign(
      level: @level
      reliability: @reliability
      carrying: @carrying
      travelSpeed: @travelSpeed
      transportGroupKey: @transportGroupKey
      materials: @materials
      isPrimary: @isPrimary
      basicPrice: @basicPrice
      ,
      super
    )

module.exports = TransportModel