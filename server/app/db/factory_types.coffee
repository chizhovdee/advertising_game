_ = require("lodash")
FactoryType = require('../game_data').FactoryType

FactoryType.define('coal_factory', (obj)->
  obj.basicPrice = 1000
  obj.buildLevel = 1
  obj.buildDuration = _(1).minutes()
  obj.upgradePerLevels = 5
  obj.baseUpgradeDuration = _(1).minutes()

  for duration in [0...FactoryType.durationsCount]
    switch duration
      when 0
        obj.durations[duration] = _(1).minutes()
        obj.addRewardForDuration(duration, (r)->
          r.material 'coal', 5
          r.experience 1
        )
      when 1
        obj.durations[duration] = _(5).minutes()
        obj.addRewardForDuration(duration, (r)->
          r.material 'coal', 10
          r.experience 2
        )
      when 2
        obj.durations[duration] = _(15).minutes()
        obj.addRewardForDuration(duration, (r)->
          r.material 'coal', 20
          r.experience 3
        )
      when 3
        obj.durations[duration] = _(1).hours()
        obj.addRewardForDuration(duration, (r)->
          r.material 'coal', 50
          r.experience 4
        )
      when 4
        obj.durations[duration] = _(4).hours()
        obj.addRewardForDuration(duration, (r)->
          r.material 'coal', 100
          r.experience 5
        )
      when 5
        obj.durations[duration] = _(8).hours()
        obj.addRewardForDuration(duration, (r)->
          r.material 'coal', 150
          r.experience 6
        )
)

FactoryType.define('wood_factory', (obj)->
  obj.basicPrice = 1000
  obj.buildLevel = 2
  obj.buildDuration = _(1).minutes()
  obj.upgradePerLevels = 5
  obj.baseUpgradeDuration = _(1).minutes()

  for duration in [0...FactoryType.durationsCount]
    switch duration
      when 0
        obj.durations[duration] = _(5).minutes()
        obj.addRewardForDuration(duration, (r)-> r.material 'wood', 5)
        obj.addRequirementForDuration(duration, (r)-> r.material 'coal', 1)
      when 1
        obj.durations[duration] = _(15).minutes()
        obj.addRewardForDuration(duration, (r)-> r.material 'wood', 10)
        obj.addRequirementForDuration(duration, (r)-> r.material 'coal', 2)
      when 2
        obj.durations[duration] = _(1).hours()
        obj.addRewardForDuration(duration, (r)-> r.material 'wood', 20)
        obj.addRequirementForDuration(duration, (r)-> r.material 'coal', 5)
      when 3
        obj.durations[duration] = _(4).hours()
        obj.addRewardForDuration(duration, (r)-> r.material 'wood', 50)
        obj.addRequirementForDuration(duration, (r)-> r.material 'coal', 10)
      when 4
        obj.durations[duration] = _(8).hours()
        obj.addRewardForDuration(duration, (r)-> r.material 'wood', 100)
        obj.addRequirementForDuration(duration, (r)-> r.material 'coal', 10)
      when 5
        obj.durations[duration] = _(24).hours()
        obj.addRewardForDuration(duration, (r)-> r.material 'wood', 150)
        obj.addRequirementForDuration(duration, (r)-> r.material 'coal', 20)
)