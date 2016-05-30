_ = require('lodash')
executor = require('../executors').properties

module.exports =
  create: (req, res)->
    req.db.tx((t)->
      req.setCurrentPlayer(yield req.currentPlayerForUpdate(t))

      result = executor.createProperty(
        req.currentPlayer
        _.toInteger(req.body.property_type_id)
      )

      res.addEventWithResult('property_created', result)

      res.updateResources(t, req.currentPlayer)
    )
    .then(->
      res.sendEventsWithProgress(req.currentPlayer)
    )
    .catch((error)->
      res.sendEventError(error)
    )
