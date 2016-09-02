_ = require('lodash')
executors = require('../executors')
factories = executors.factories

module.exports =
  update: (req, res)->
    [controller, action] = req.path.slice(1).split('/')

    req.db.tx((t)->
      resourcesForSaving = [] # сюда записиваем ресурсы и объекты, которые должны сохраниться в хранилища

      req.setCurrentPlayer(yield req.currentPlayerForUpdate(t))

      switch controller
        when 'factories'
          switch action
            when 'create'
              result = factories.createFactory(req.currentPlayer,
                _.toInteger(req.body.factory_type_id)
              )
            when 'accelerate'
              result = factories.accelerateFactory(req.currentPlayer,
                _.toInteger(req.body.factory_id)
              )
            when 'upgrade'
              result = factories.upgradeFactory(req.currentPlayer,
                _.toInteger(req.body.factory_id)
              )
            when 'start'
              result = factories.startFactory(req.currentPlayer,
                _.toInteger(req.body.factory_id),
                _.toInteger(req.body.duration_number)
              )

      res.addEventWithResult([controller, action], result)

      resourcesForSaving.push(req.currentPlayer)

      res.saveResources(t, resourcesForSaving...)
    )
    .then(->
      res.sendEventsWithProgress(req.currentPlayer)
    )
    .catch((error)->
      res.sendEventError(error)
    )