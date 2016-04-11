TransportType = require('../game_data').TransportType

for type in ['auto', 'sea', 'air', 'railway']
  TransportType.define(type)