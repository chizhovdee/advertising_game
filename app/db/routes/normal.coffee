require('../route_types')

Route = require('../../game_data').Route

Route.define('everyday_van_1', (obj)->
  obj.typeKey = 'normal'

  obj.reputation = 0

  obj.goodTypeKey = 'everyday'
  obj.transportTypeKey = 'auto'

  obj.distance = 10
  obj.weight = 0.1

  obj.addReward 'collect', (r)->
    r.reputation 1
    r.experience 1
    r.basicMoney 10
)

Route.define('industrial_van_2', (obj)->
  obj.typeKey = 'normal'

  obj.reputation = 0

  obj.goodTypeKey = 'industrial'
  obj.transportTypeKey = 'auto'

  obj.distance = 10
  obj.weight = 0.1

  obj.addReward 'collect', (r)->
    r.reputation 2
    r.experience 1
    r.basicMoney 15
)

Route.define('industrial_3', (obj)->
  obj.typeKey = 'normal'

  obj.reputation = 2

  obj.goodTypeKey = 'industrial'
  obj.transportTypeKey = 'auto'

  obj.distance = 15
  obj.weight = 0.2

  obj.addReward 'collect', (r)->
    r.reputation 1
    r.experience 2
    r.basicMoney 15
)

Route.define('everyday_van_4', (obj)->
  obj.typeKey = 'normal'

  obj.reputation = 2

  obj.goodTypeKey = 'everyday'
  obj.transportTypeKey = 'auto'

  obj.distance = 15
  obj.weight = 0.2

  obj.addReward 'collect', (r)->
    r.reputation 1
    r.experience 2
    r.basicMoney 15
)