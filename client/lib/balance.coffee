ctx = require('../context')

module.exports =
  acceleratePrice: (duration)->
    Math.ceil(duration / ctx.get('settings').balanceSettings.accelerate)
