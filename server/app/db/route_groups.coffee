RouteGroup = require('../game_data').RouteGroup

RouteGroup.define('route_group_1', (obj)->
  obj.addRequirement('open', (r)->
    r.reputation 1
  )
)

RouteGroup.define('route_group_2', (obj)->
  obj.addRequirement('open', (r)->
    r.reputation 100
  )
)