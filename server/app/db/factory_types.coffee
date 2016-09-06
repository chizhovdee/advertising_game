_ = require("lodash")
FactoryType = require('../game_data').FactoryType

FactoryType.define('coal_factory', (obj)->
  obj.basicPrice = 1000
  obj.buildLevel = 1
  obj.buildDuration = _(1).minutes()
  obj.upgradePerLevels = 5
  obj.baseUpgradeDuration = _(1).minutes()

  for production in FactoryType.productionNumbers
    switch production
      when 0
        obj.productions[production] = _(1).minutes()
        obj.addRewardForProduction(production, (r)->
          r.material 'coal', 5
          r.experience 1
        )
      when 1
        obj.productions[production] = _(5).minutes()
        obj.addRewardForProduction(production, (r)->
          r.material 'coal', 10
          r.experience 2
        )
      when 2
        obj.productions[production] = _(15).minutes()
        obj.addRewardForProduction(production, (r)->
          r.material 'coal', 20
          r.experience 3
        )
      when 3
        obj.productions[production] = _(1).hours()
        obj.addRewardForProduction(production, (r)->
          r.material 'coal', 50
          r.experience 4
        )
      when 4
        obj.productions[production] = _(4).hours()
        obj.addRewardForProduction(production, (r)->
          r.material 'coal', 100
          r.experience 5
        )
      when 5
        obj.productions[production] = _(8).hours()
        obj.addRewardForProduction(production, (r)->
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

  for production in FactoryType.productionNumbers
    switch production
      when 0
        obj.productions[production] = _(5).minutes()

        obj.addRewardForProduction(production, (r)->
          r.material 'wood', 5
          r.experience 1
        )

        obj.addRequirementForProduction(production, (r)-> r.material 'coal', 1)
      when 1
        obj.productions[production] = _(15).minutes()

        obj.addRewardForProduction(production, (r)->
          r.material 'wood', 10
          r.experience 2
        )

        obj.addRequirementForProduction(production, (r)-> r.material 'coal', 2)
      when 2
        obj.productions[production] = _(1).hours()

        obj.addRewardForProduction(production, (r)->
          r.material 'wood', 20
          r.experience 3
        )

        obj.addRequirementForProduction(production, (r)-> r.material 'coal', 5)
      when 3
        obj.productions[production] = _(4).hours()

        obj.addRewardForProduction(production, (r)->
          r.material 'wood', 50
          r.experience 4
        )

        obj.addRequirementForProduction(production, (r)-> r.material 'coal', 10)
      when 4
        obj.productions[production] = _(8).hours()

        obj.addRewardForProduction(production, (r)->
          r.material 'wood', 100
          r.experience 5
        )

        obj.addRequirementForProduction(production, (r)-> r.material 'coal', 10)
      when 5
        obj.productions[production] = _(24).hours()

        obj.addRewardForProduction(production, (r)->
          r.material 'wood', 150
          r.experience 6
        )

        obj.addRequirementForProduction(production, (r)-> r.material 'coal', 20)
)