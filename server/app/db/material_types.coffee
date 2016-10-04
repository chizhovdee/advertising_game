MaterialType = require('../game_data').MaterialType

MaterialType.define('coal', (obj)->
  obj.townLevel = 1
  obj.sellBasicPrice = 10
)

MaterialType.define('wood', (obj)->
  obj.townLevel = 2
  obj.sellBasicPrice = 15
)

MaterialType.define('iron_ore', (obj)->
  obj.townLevel = 3
  obj.sellBasicPrice = 20
)
