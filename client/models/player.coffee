ctx = require("../context")
time = require('../utils').time

class Player extends Spine.Model
  @configure "Player", "oldAttributes", "level", "town_level", "experience", "basic_money", "vip_money",
    'experience_to_next_level', 'level_progress_percentage', 'reputation',
    'fuel', 'locale', 'town_bonus_collected_at', 'town_upgrade_at'

  @include require('./modules/model_changes')

  update: ->
    @.setOldAttributes(@constructor.irecords[@id].attributes())

    super

module.exports = Player

