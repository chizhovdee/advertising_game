_ = require('lodash')
executor = require('../executors').staff

module.exports =
  hire: (req, res)->
    req.db.tx((t)->
      req.setCurrentPlayer(yield req.currentPlayerForUpdate(t))

      result = executor.hire(
        req.currentPlayer
        req.body.employee_type
        _.toInteger(req.body.package)
      )

      res.addEventWithResult('staff_hired', result)

      res.updateResources(t)
    )
    .then(->
      res.sendEventsWithProgress()
    )
    .catch((error)->
      res.sendEventError(error)
    )