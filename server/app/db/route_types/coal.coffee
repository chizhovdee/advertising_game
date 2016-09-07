require('../route_groups')

RouteType = require('../../game_data').RouteType

routeGroupKey = 'coal_route_group'
materialKey = 'coal'

routeTypeKey = 'route_type'
index = 0

RouteType.define("#{routeTypeKey}_#{index += 1}", (obj)->
  obj.routeGroupKey = routeGroupKey
  obj.materialKey = materialKey

  obj.distance = 10
  obj.weight = 100

  obj.level = 1

  obj.addReward('collect', (r)->
    # TODO реализовать методы баланса
    r.reputation 1
    r.basicMoney 10
    r.experience 1
  )
)

RouteType.define("#{routeTypeKey}_#{index += 1}", (obj)->
  obj.routeGroupKey = routeGroupKey
  obj.materialKey = materialKey

  obj.distance = 20
  obj.weight = 100

  obj.level = 0

  obj.addReward('collect', (r)->
    r.reputation 2
    r.basicMoney 20
    r.experience 2
  )
)

RouteType.define("#{routeTypeKey}_#{index += 1}", (obj)->
  obj.routeGroupKey = routeGroupKey
  obj.materialKey = materialKey

  obj.distance = 30
  obj.weight = 100

  obj.level = 2

  obj.addReward('collect', (r)->
    r.reputation 3
    r.basicMoney 30
    r.experience 3
  )
)

RouteType.define("#{routeTypeKey}_#{index += 1}", (obj)->
  obj.routeGroupKey = routeGroupKey
  obj.materialKey = materialKey

  obj.distance = 40
  obj.weight = 100

  obj.level = 5

  obj.addReward('collect', (r)->
    r.reputation 4
    r.basicMoney 40
    r.experience 4
  )
)

RouteType.define("#{routeTypeKey}_#{index += 1}", (obj)->
  obj.routeGroupKey = routeGroupKey
  obj.materialKey = materialKey

  obj.distance = 40
  obj.weight = 200

  obj.level = 15

  obj.addReward('collect', (r)->
    r.reputation 5
    r.basicMoney 50
    r.experience 5
  )
)