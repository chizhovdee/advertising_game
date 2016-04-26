RouteType = require('../game_data').RouteType

RouteType.define('auto', (obj)-> obj.level = 1)

RouteType.define('railway', (obj)-> obj.level = 10)

RouteType.define('air', (obj)-> obj.level = 100)

RouteType.define('sea', (obj)-> obj.level = 500)