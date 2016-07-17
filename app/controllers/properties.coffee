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

  accelerate: (req, res)->
    req.db.tx((t)->
      req.setCurrentPlayer(yield req.currentPlayerForUpdate(t))

      result = executor.accelerateProperty(
        req.currentPlayer
        _.toInteger(req.body.property_id)
      )

      res.addEventWithResult('property_accelerated', result)

      res.updateResources(t, req.currentPlayer)
    )
    .then(->
      res.sendEventsWithProgress(req.currentPlayer)
    )
    .catch((error)->
      res.sendEventError(error)
    )

  upgrade: (req, res)->
    req.db.tx((t)->
      req.setCurrentPlayer(yield req.currentPlayerForUpdate(t))

      result = executor.upgradeProperty(
        req.currentPlayer
        _.toInteger(req.body.property_id)
      )

      res.addEventWithResult('property_upgraded', result)

      res.updateResources(t, req.currentPlayer)
    )
    .then(->
      res.sendEventsWithProgress(req.currentPlayer)
    )
    .catch((error)->
      res.sendEventError(error)
    )

  rentOut: (req, res)->
    req.db.tx((t)->
      req.setCurrentPlayer(yield req.currentPlayerForUpdate(t))

      result = executor.rentOutProperty(
        req.currentPlayer
        _.toInteger(req.body.property_id)
      )

      res.addEventWithResult('property_rented', result)

      res.updateResources(t, req.currentPlayer)
    )
    .then(->
      res.sendEventsWithProgress(req.currentPlayer)
    )
    .catch((error)->
      res.sendEventError(error)
    )

  collectRent:(req, res)->
    req.db.tx((t)->
      req.setCurrentPlayer(yield req.currentPlayerForUpdate(t))

      result = executor.collectRent(
        req.currentPlayer
        _.toInteger(req.body.property_id)
      )

      res.addEventWithResult('property_rent_collected', result)

      res.updateResources(t, req.currentPlayer)
    )
    .then(->
      res.sendEventsWithProgress(req.currentPlayer)
    )
    .catch((error)->
      res.sendEventError(error)
    )