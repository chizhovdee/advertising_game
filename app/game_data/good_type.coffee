_ = require("lodash")
Base = require("./base")

# тип товаров / груза
class GoodType extends Base
  @configure()

  constructor: ->
    Object.defineProperties(@,
      _goods: {
        value: []
        writable: false
      }
      goods: {
        enumerable: true
        get: -> @_goods
      }
    )

  addGood: (good)->
    _.addUniq(@_goods, good)

  validationForDefine: ->
    # empty

module.exports = GoodType