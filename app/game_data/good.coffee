_ = require("lodash")
Base = require("./base")
GoodType = require('./good_type')

# товар/груз
class Good extends Base
  typeKey: null
  food: false # пищевой или нет

  @configure()

  @afterDefine 'setType'

  constructor: ->
    super

    @food = false

  setType: ->
    Object.defineProperty(@, 'type'
      value: GoodType.find(@typeKey)
      writable: false
      enumerable: true
    )

    @type.addGood(@)

  validationForDefine: ->
    return new Error('undefined typeKey') unless @typeKey?
    

module.exports = Good