settings = require('../settings')

module.exports =
  acceleratePrice: (duration)->
    Math.ceil(duration / settings.balanceSettings.accelerate)

  fuelBasicPrice: (fuel)->
    settings.balanceSettings.fuelBasicPrice[fuel]