module.exports =
  hire: (req, res)->
    req.db.tx((t)->
      req.setCurrentPlayer(yield req.currentPlayerForUpdate(t))

#      result = executor.performQuest(_.toInteger(req.body.quest_id), character)

      result = {isError: -> false}
      res.addEventWithResult('staff_hired', result)

      res.updateResources(t)
    )
    .then(->
      res.sendEventsWithProgress()
    )
    .catch((error)->
      res.sendEventError(error)
    )