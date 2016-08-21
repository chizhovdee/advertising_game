#settings = require('../settings')

module.exports =
  acceleratePrice: (duration)->
    Math.ceil(duration / settings.balanceSettings.accelerate)

  fuelBasicPrice: ->
    settings.balanceSettings.fuelBasicPrice