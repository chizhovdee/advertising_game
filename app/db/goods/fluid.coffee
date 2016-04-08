require('../good_types') # загружаем в первую очередь
Good = require('../../game_data').Good

goods = {
  food: ['edible_oil', 'water', 'milk']
  nonFood: ['fuel']
}

for goodKey in goods.food
  Good.define(goodKey, (obj)->
    obj.typeKey = 'fluid'
    obj.food = true
  )

for goodKey in goods.nonFood
  Good.define(goodKey, (obj)->
    obj.typeKey = 'fluid'
    obj.food = false
  )
