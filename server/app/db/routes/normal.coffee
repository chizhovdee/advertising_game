Route = require('../../game_data').Route
Good = require('../../game_data').Good

status = 'normal'

Route.define('everyday_van_1', (obj)->
  obj.status = status

  obj.reputation = 0
  obj.distance = 10
  obj.weight = 0.1
  obj.goodKey = Good.types.everyday

  obj.addReward 'collect', (r)->
    r.reputation 1
    r.experience 1
    r.basicMoney 10
)

Route.define('industrial_van_2', (obj)->
  obj.status = status

  obj.reputation = 0
  obj.distance = 10
  obj.weight = 0.1
  obj.goodKey = Good.types.industrial

  obj.addReward 'collect', (r)->
    r.reputation 1
    r.experience 1
    r.basicMoney 10
)