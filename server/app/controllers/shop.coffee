_ = require('lodash')
executor = require('../executors').shop

module.exports =
  buyTransport: (req, res)->
    req.db.tx((t)->
      req.setCurrentPlayer(yield req.currentPlayerForUpdate(t))

      result = executor.buyTransport(
        req.currentPlayer
        req.body.transport_model_id
      )

      res.addEventWithResult('transport_purchased', result)

      res.updateResources(t, req.currentPlayer)
    )
    .then(->
      res.sendEventsWithProgress(req.currentPlayer)
    )
    .catch((error)->
      res.sendEventError(error)
    )

  buyFuel: (req, res)->
    req.db.tx((t)->
      req.setCurrentPlayer(yield req.currentPlayerForUpdate(t))

      result = executor.buyFuel(
        req.currentPlayer
        _.toInteger(req.body.amount)
      )

      res.addEventWithResult('fuel_purchased', result)

      res.updateResources(t, req.currentPlayer)
    )
    .then(->
      res.sendEventsWithProgress(req.currentPlayer)
    )
    .catch((error)->
      res.sendEventError(error)
    )
