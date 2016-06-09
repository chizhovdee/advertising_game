_ = require('lodash')
executor = require('../executors').shop

module.exports =
  buy: (req, res)->
    req.db.tx((t)->
      req.setCurrentPlayer(yield req.currentPlayerForUpdate(t))

      result = executor.buy(
        req.currentPlayer
        _.toInteger(req.body.item_id)
      )

      res.addEventWithResult('item_purchased', result)

      res.updateResources(t, req.currentPlayer)
    )
    .then(->
      res.sendEventsWithProgress(req.currentPlayer)
    )
    .catch((error)->
      res.sendEventError(error)
    )
