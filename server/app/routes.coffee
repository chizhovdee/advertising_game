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
    apiRoutes.put('/advertising/prolong', controllers.advertising.prolong)

    # routes
    apiRoutes.put('/routes/open', controllers.routes.open)

    # shop
    apiRoutes.post('/shop/buy_transport', controllers.shop.buyTransport)
    apiRoutes.put('/shop/buy_fuel', controllers.shop.buyFuel)

    # trucking
    apiRoutes.post('/trucking/create', controllers.trucking.create)
    apiRoutes.put('/trucking/collect', controllers.trucking.collect)

    # factories
    apiRoutes.post('/factories/create', controllers.gameApi.action)
    apiRoutes.put('/factories/accelerate', controllers.gameApi.action)
    apiRoutes.put('/factories/upgrade', controllers.gameApi.action)
