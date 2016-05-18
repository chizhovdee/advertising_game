require('../route_types')

Route = require('../../game_data').Route

Route.define('everyday_van_1', (obj)->
  obj.typeKey = 'auto'
  obj.level = 1

  obj.goodTypeKey = 'everyday'
  obj.distance = 10
  obj.weight = 0.1

  obj.addReward 'collect', (r)->
    r.reputation 1
    r.experience 1
    r.basicMoney 10
)