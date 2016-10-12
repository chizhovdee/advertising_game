express = require('express')
middleware = require('./lib/middleware')
controllers = require('./controllers')

exports.setup = (app)->
  # home index
  app.get("/", controllers.home.index)

  # api routes
  do (apiRoutes = express.Router())->
    app.use("/api/:version", apiRoutes)

    # properties
    apiRoutes.post('/properties/create', controllers.gameApi.update)
    apiRoutes.put('/properties/accelerate', controllers.gameApi.update)
    apiRoutes.put('/properties/upgrade', controllers.gameApi.update)

    # advertising
    apiRoutes.post('/advertising/create', controllers.gameApi.update)
    apiRoutes.delete('/advertising/delete', controllers.gameApi.update)
    apiRoutes.put('/advertising/prolong', controllers.gameApi.update)

    # transport
    apiRoutes.put('/transport/purchase', controllers.gameApi.update)

    # trucking
    apiRoutes.post('/trucking/create', controllers.gameApi.update)
    apiRoutes.put('/trucking/collect', controllers.gameApi.update)
    apiRoutes.put('/trucking/accelerate', controllers.gameApi.update)

    # factories
    apiRoutes.post('/factories/create', controllers.gameApi.update)
    apiRoutes.put('/factories/accelerate', controllers.gameApi.update)
    apiRoutes.put('/factories/upgrade', controllers.gameApi.update)
    apiRoutes.put('/factories/start', controllers.gameApi.update)
    apiRoutes.put('/factories/collect', controllers.gameApi.update)

    # town
    apiRoutes.put('/town/collect_bonus', controllers.gameApi.update)
    apiRoutes.put('/town/upgrade', controllers.gameApi.update)
    apiRoutes.put('/town/accelerate', controllers.gameApi.update)

