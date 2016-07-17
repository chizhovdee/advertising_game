_ = require('lodash')

module.exports =
  settings:
    accelerate: _(10).minutes() # 1 gold per duration

  acceleratePrice: (duration)->
    Math.ceil(duration / @settings.accelerate)
