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
    apiRoutes.post('/properties/create', controllers.gameApi.update)
    apiRoutes.put('/properties/accelerate', controllers.gameApi.update)
    apiRoutes.put('/properties/upgrade', controllers.gameApi.update)

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
    apiRoutes.post('/factories/create', controllers.gameApi.update)
    apiRoutes.put('/factories/accelerate', controllers.gameApi.update)
    apiRoutes.put('/factories/upgrade', controllers.gameApi.update)
    apiRoutes.put('/factories/start', controllers.gameApi.update)
    apiRoutes.put('/factories/collect', controllers.gameApi.update)
