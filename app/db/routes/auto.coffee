require('../route_types')

Route = require('../../game_data').Route

Route.define('auto_1', (obj)->
  obj.typeKey = 'auto'
  obj.goodKey = 'cement'
  obj.distance = 50
  obj.weight = 0.1

  obj.addRequirement 'start', (r)->
    r.reputation 0

  obj.addReward 'collect', (r)->
    r.reputation 1
    r.experience 5
    r.basicMoney 10
)

Route.define('auto_2', (obj)->
  obj.typeKey = 'auto'
  obj.goodKey = 'sand'
  obj.distance = 50
  obj.weight = 0.1

  obj.addRequirement 'start', (r)->
    r.reputation 1

  obj.addReward 'collect', (r)->
    r.reputation 2
    r.experience 10
    r.basicMoney 20
)

Route.define('auto_3', (obj)->
  obj.typeKey = 'auto'
  obj.goodKey = 'rubble'
  obj.distance = 50
  obj.weight = 0.1

  obj.addRequirement 'start', (r)->
    r.reputation 5

  obj.addReward 'collect', (r)->
    r.reputation 3
    r.experience 15
    r.basicMoney 25
)