Advertising = require('../game_data').Advertising

Advertising.define('newspaper', (obj)->
  obj.level = 1
  obj.basicPrice = 5
)

Advertising.define('radio', (obj)->
  obj.level = 10
  obj.basicPrice = 10
)

Advertising.define('tv', (obj)->
  obj.level = 20
  obj.basicPrice = 15
)

Advertising.define('internet', (obj)->
  obj.level = 30
  obj.basicPrice = 20
)