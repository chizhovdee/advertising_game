require('../good_types') # загружаем в первую очередь
Good = require('../../game_data').Good

goods = {
  food: ['grain', 'sugar']
  nonFood: ['sand', 'rubble', 'ore', 'scrap']
}

for goodKey in goods.food
  Good.define(goodKey, (obj)->
    obj.typeKey = 'bulk'
    obj.food = true
  )

for goodKey in goods.nonFood
  Good.define(goodKey, (obj)->
    obj.typeKey = 'bulk'
    obj.food = false
  )
