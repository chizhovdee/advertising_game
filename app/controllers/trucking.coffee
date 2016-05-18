_ = require('lodash')
executor = require('../executors').trucking

module.exports =
  index: (req, res)->
    req.findCurrentPlayer()
    .then(->
      res.sendEvent("trucking_loaded", (data)->
        data.trucking = req.currentPlayer.truckingState.allForClient()
      )
    )
    .catch(
      (err)-> res.sendEventError(err)
    )

  create: (req, res)->
    req.db.tx((t)->
      req.setCurrentPlayer(yield req.currentPlayerForUpdate(t))

      result = executor.createTrucking(
        req.currentPlayer
        _.toInteger(req.body.route_id)
        _.toInteger(req.body.transport_id)
      )

      res.addEventWithResult('trucking_created', result)

      res.updateResources(t, req.currentPlayer)
    )
    .then(->
      res.sendEventsWithProgress(req.currentPlayer)
    )
    .catch((error)->
      res.sendEventError(error)
    )

  collect: (req, res)->
    req.db.tx((t)->
      req.setCurrentPlayer(yield req.currentPlayerForUpdate(t))

      result = executor.collectTrucking(
        req.currentPlayer
        _.toInteger(req.body.trucking_id)
      )

      res.addEventWithResult('trucking_collected', result)

      res.updateResources(t, req.currentPlayer)
    )
    .then(->
      res.sendEventsWithProgress(req.currentPlayer)
    )
    .catch((error)->
      res.sendEventError(error)
    )
