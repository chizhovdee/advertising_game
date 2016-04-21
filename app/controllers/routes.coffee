module.exports =
  index: (req, res)->
    req.findCurrentPlayer()
    .then(->
      res.sendEvent("routes_loaded", (data)->

      )
    )
    .catch(
      (err)-> res.sendEventError(err)
    )
