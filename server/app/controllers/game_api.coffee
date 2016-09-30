_ = require('lodash')
executors = require('../executors')
factories = executors.factories
properties = executors.properties
shop = executors.shop
advertising = executors.advertising
trucking = executors.trucking
town = executors.town

module.exports =
  update: (req, res)->
    [controller, action] = req.path.slice(1).split('/')

    req.db.tx((t)->
      resourcesForSaving = [] # сюда записиваем ресурсы и объекты, которые должны сохраниться в хранилища

      req.setCurrentPlayer(yield req.currentPlayerForUpdate(t))

      switch controller
        when 'factories'
          switch action
            when 'create'
              result = factories.createFactory(req.currentPlayer,
                _.toInteger(req.body.factory_type_id)
              )
            when 'accelerate'
              result = factories.accelerateFactory(req.currentPlayer,
                _.toInteger(req.body.factory_id)
              )
            when 'upgrade'
              result = factories.upgradeFactory(req.currentPlayer,
                _.toInteger(req.body.factory_id)
              )
            when 'start'
              result = factories.startFactory(req.currentPlayer,
                _.toInteger(req.body.factory_id),
                _.toInteger(req.body.production_number)
              )
            when 'collect'
              result = factories.collectFactory(req.currentPlayer,
                _.toInteger(req.body.factory_id)
              )

        when 'properties'
          switch action
            when 'create'
              result = properties.createProperty(
                req.currentPlayer
                _.toInteger(req.body.property_type_id)
              )
            when 'accelerate'
              result = properties.accelerateProperty(
                req.currentPlayer
                _.toInteger(req.body.property_id)
              )
            when 'upgrade'
              result = properties.upgradeProperty(
                req.currentPlayer
                _.toInteger(req.body.property_id)
              )

        when 'shop'
          switch action
            when 'buy_transport'
              result = shop.buyTransport(
                req.currentPlayer
                req.body.transport_model_id
              )
            when 'buy_fuel'
              result = shop.buyFuel(
                req.currentPlayer
                _.toInteger(req.body.amount)
              )

        when 'advertising'
          switch action
            when 'create'
              result = advertising.createAdvertising(
                req.currentPlayer
                _.parseRequestParams(req.body).data
              )
            when 'delete'
              result = advertising.deleteAdvertising(
                req.currentPlayer
                _.toInteger(req.body.advertising_id)
              )
            when 'prolong'
              result = advertising.prolongAdvertising(
                req.currentPlayer
                _.toInteger(req.body.advertising_id)
                _.toInteger(req.body.period)
              )

        when 'trucking'
          switch action
            when 'create'
              result = trucking.createTrucking(
                req.currentPlayer
                _.parseRequestParams(req.body, parse_values: true)
              )
            when 'collect'
              result = trucking.collectTrucking(
                req.currentPlayer
                _.toInteger(req.body.trucking_id)
              )
            when 'accelerate'
              result = trucking.accelerateTrucking(
                req.currentPlayer
                _.toInteger(req.body.trucking_id)
              )

        when 'town'
          switch action
            when 'collect_bonus'
              result = town.collectBonus(req.currentPlayer)

      res.addEventWithResult([controller, action], result)

      resourcesForSaving.push(req.currentPlayer)

      res.saveResources(t, resourcesForSaving...)
    )
    .then(->
      res.sendEventsWithProgress(req.currentPlayer)
    )
    .catch((error)->
      res.sendEventError(error)
    )