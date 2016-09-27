TownLevel = require('../../game_data').TownLevel

number = 0

# 1
TownLevel.define("town_level_#{number += 1}", (obj)->
  obj.number = number

  obj.addMaterial 'wood', 300
)

# 2
TownLevel.define("town_level_#{number += 1}", (obj)->
  obj.number = number

  obj.addMaterial 'iron_ore', 400
)

# 3
TownLevel.define("town_level_#{number += 1}", (obj)->
  obj.number = number
)