_ = require('lodash')

module.exports =
  settings:
    accelerate: _(10).minutes() # 1 gold per duration
    fuelBasicPrice: 10

  acceleratePrice: (duration)->
    Math.ceil(duration / @settings.accelerate)

  fuelBasicPrice: ->
    @settings.fuelBasicPrice
