express = require('express')
middleware = require('./lib/middleware')
controllers = require('./controllers')

exports.setup = (app)->
  # home index
  app.get("/", controllers.home.index)

#
  # api routes
  do (apiRoutes = express.Router())->
    app.use("/api/:version", apiRoutes)

    apiRoutes.get("/game_data.json", controllers.home.gameData)

#    # staff
#    apiRoutes.post('/staff/hire.json', controllers.staff.hire)
#

#



#
#    # transport
#    apiRoutes.get('/transport', controllers.transport.index)

    # properties
    apiRoutes.post('/properties/create', controllers.properties.create)

    # advertising
    apiRoutes.post('/advertising/create', controllers.advertising.create)

    # routes
    apiRoutes.put('/routes/open', controllers.routes.open)

    # shop
    apiRoutes.post('/shop/buy', controllers.shop.buy)

    # trucking
    apiRoutes.post('/trucking/create', controllers.trucking.create)
    apiRoutes.put('/trucking/collect', controllers.trucking.collect)
