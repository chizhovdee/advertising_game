_ = require('lodash')
executor = require('../executors').advertising

module.exports =
  create: (req, res)->
    req.db.tx((t)->
      req.setCurrentPlayer(yield req.currentPlayerForUpdate(t))

      result = executor.createAdvertising(
        req.currentPlayer
        _.parseRequestParams(req.body).data
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
