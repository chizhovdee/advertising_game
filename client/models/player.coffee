settings = require('../settings')

class Player extends Spine.Model
  @configure "Player", "oldAttributes", "level", "experience", "basic_money", "vip_money",
    'experience_to_next_level', 'level_progress_percentage', 'reputation', 'fuel'

  @include require('./modules/model_changes')

  update: ->
    @.setOldAttributes(@constructor.irecords[@id].attributes())

    super

  acceleratePrice: (duration)->
    Math.ceil(duration / settings.player.balance.accelerate)

module.exports = Player

