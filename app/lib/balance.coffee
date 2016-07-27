_ = require('lodash')

module.exports =
  settings:
    accelerate: _(10).minutes() # 1 gold per duration
    fuelBasicPrice: # за одну единицу товара
      auto: 10
      air: 150
      railway: 50
      sea: 100

  acceleratePrice: (duration)->
    Math.ceil(duration / @settings.accelerate)

  fuelBasicPrice: (fuel)->
    @settings.fuelBasicPrice[fuel]
