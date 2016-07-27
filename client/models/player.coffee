class Player extends Spine.Model
  @configure "Player", "oldAttributes", "level", "experience", "basic_money", "vip_money",
    'experience_to_next_level', 'level_progress_percentage', 'reputation',
    'fuel_auto', 'fuel_railway', 'fuel_air', 'fuel_sea'

  @include require('./modules/model_changes')

  update: ->
    @.setOldAttributes(@constructor.irecords[@id].attributes())

    super

module.exports = Player

