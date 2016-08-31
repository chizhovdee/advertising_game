_ = require('lodash')
executors = require('../executors')

module.exports =
  action: (req, res)->
    [controller, action] = req.path.slice(1).split('/')

    req.db.tx((t)->
      req.setCurrentPlayer(yield req.currentPlayerForUpdate(t))

      switch controller
        when 'factories'
          switch action
            when 'create'
              1
            when 'accelerate'
              2
            when 'upgrade'
              3

      res.addEventWithResult([controller, action], result)

      res.updateResources(t, req.currentPlayer)
    )
    .then(->
      res.sendEventsWithProgress(req.currentPlayer)
    )
    .catch((error)->
      res.sendEventError(error)
    )