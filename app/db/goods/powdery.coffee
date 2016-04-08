require('../good_types') # загружаем в первую очередь
Good = require('../../game_data').Good

goods = {
  food: ['flour']
  nonFood: ['cement', 'lime', 'fertilizer']
}

for goodKey in goods.food
  Good.define(goodKey, (obj)->
    obj.typeKey = 'powdery'
    obj.food = true
  )

for goodKey in goods.nonFood
  Good.define(goodKey, (obj)->
    obj.typeKey = 'powdery'
    obj.food = false
  )
