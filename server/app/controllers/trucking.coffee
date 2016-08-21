_ = require('lodash')
executor = require('../executors').trucking

module.exports =
  create: (req, res)->
    req.db.tx((t)->
      req.setCurrentPlayer(yield req.currentPlayerForUpdate(t))

      result = executor.createTrucking(
        req.currentPlayer
        _.toInteger(req.body.state_route_id)
        _.map(req.body.transport_ids.split(','), (tId)-> _.toInteger(tId))
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
