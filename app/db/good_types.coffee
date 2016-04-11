GoodType = require('../game_data').GoodType

types = [
  'bulk', 'powdery', 'fluid', 'gas', 'food', 'medicines', 'chemicals', 'animals', 'dangerous',
  'lengthy', 'oversized', 'container', 'common', 'industrial', 'clothes', 'different'
]

for type in types
  GoodType.define(type)