MaterialType = require('../game_data').MaterialType

MaterialType.define('coal', (obj)-> obj.townLevel = 1)

MaterialType.define('wood', (obj)-> obj.townLevel = 2)

MaterialType.define('iron_ore', (obj)-> obj.townLevel = 3)
