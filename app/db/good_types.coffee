GoodType = require('../game_data').GoodType

types = [
  'everyday', 'industrial'
]

for type in types
  GoodType.define(type)