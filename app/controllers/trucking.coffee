module.exports =
  index: (req, res)->
    req.findCurrentPlayer()
    .then(->
      res.sendEvent("trucking_loaded", (data)->

      )
    )
    .catch(
      (err)-> res.sendEventError(err)
    )
