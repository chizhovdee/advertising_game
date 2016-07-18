GoodType = require('../game_data').GoodType

types = [
  'everyday', 'industrial', 'any'
]

for type in types
  GoodType.define(type)