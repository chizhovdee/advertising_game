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
    apiRoutes.put('/properties/accelerate', controllers.properties.accelerate)
    apiRoutes.put('/properties/upgrade', controllers.properties.upgrade)
    apiRoutes.put('/properties/rent_out', controllers.properties.rentOut)
    apiRoutes.put('/properties/collect_rent', controllers.properties.collectRent)
    apiRoutes.put('/properties/finish_rent', controllers.properties.finishRent)

    # advertising
    apiRoutes.post('/advertising/create', controllers.advertising.create)
    apiRoutes.delete('/advertising/delete', controllers.advertising.delete)

    # routes
    apiRoutes.put('/routes/open', controllers.routes.open)

    # shop
    apiRoutes.post('/shop/buy', controllers.shop.buy)

    # trucking
    apiRoutes.post('/trucking/create', controllers.trucking.create)
    apiRoutes.put('/trucking/collect', controllers.trucking.collect)
