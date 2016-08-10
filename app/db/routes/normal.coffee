Route = require('../../game_data').Route

Route.define('everyday_van_1', (obj)->
  obj.tag = 'normal'

  obj.reputation = 0
  obj.distance = 10
  obj.weight = 0.1
  obj.goodKey = 'any'

  obj.addReward 'collect', (r)->
    r.reputation 1
    r.experience 1
    r.basicMoney 10
)