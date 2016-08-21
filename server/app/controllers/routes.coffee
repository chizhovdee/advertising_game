_ = require('lodash')
executor = require('../executors').routes

module.exports =
  open: (req, res)->
    req.db.tx((t)->
      req.setCurrentPlayer(yield req.currentPlayerForUpdate(t))

      result = executor.openRoute(
        req.currentPlayer
        _.toInteger(req.body.advertising_id)
      )

      res.addEventWithResult('route_opened', result)

      res.updateResources(t, req.currentPlayer)
    )
    .then(->
      res.sendEventsWithProgress(req.currentPlayer)
    )
    .catch((error)->
      res.sendEventError(error)
    )

