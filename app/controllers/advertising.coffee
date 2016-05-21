_ = require('lodash')
executor = require('../executors').advertising

module.exports =
  index: (req, res)->
    req.findCurrentPlayer()
    .then(->
      res.sendEvent("advertising_loaded", (data)->
        data.advertising = []
      )
    )
    .catch(
      (err)-> res.sendEventError(err)
    )

  create: (req, res)->
    req.db.tx((t)->
      req.setCurrentPlayer(yield req.currentPlayerForUpdate(t))

      result = executor.create(
        req.currentPlayer
        _.parseRequestParams(req.body)
      )

      res.addEventWithResult('advertising_created', result)

      res.updateResources(t, req.currentPlayer)
    )
    .then(->
      res.sendEventsWithProgress(req.currentPlayer)
    )
    .catch((error)->
      res.sendEventError(error)
    )
