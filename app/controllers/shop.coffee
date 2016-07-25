_ = require('lodash')
executor = require('../executors').shop

module.exports =
  buy: (req, res)->
    req.db.tx((t)->
      req.setCurrentPlayer(yield req.currentPlayerForUpdate(t))

      result = executor.buy(
        req.currentPlayer
        req.body.item_id
        req.body.item_type
        _.toInteger(req.body.amount)
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
