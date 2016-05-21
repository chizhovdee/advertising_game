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
#    # properties
#    apiRoutes.get('/properties', controllers.properties.index)
#
#    # trucking
#    apiRoutes.get('/trucking', controllers.trucking.index)
#    apiRoutes.post('/trucking/create', controllers.trucking.create)
#    apiRoutes.put('/trucking/collect', controllers.trucking.collect)
#
#    # routes
#    apiRoutes.get('/routes', controllers.routes.index)
#
#    # transport
#    apiRoutes.get('/transport', controllers.transport.index)

    # advertising
    apiRoutes.get('/advertising', controllers.advertising.index)
    apiRoutes.post('/advertising/create', controllers.advertising.create)
