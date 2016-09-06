MaterialType = require('../game_data').MaterialType

MaterialType.define('coal', (obj)-> obj.level = 1)

MaterialType.define('wood', (obj)-> obj.level = 2)

MaterialType.define('iron_ore', (obj)-> obj.level = 3)
