module.exports =
  index: (req, res)->
    req.findCurrentPlayer()
    .then(->
      res.sendEvent("properties_loaded", (data)->

      )
    )
    .catch(
      (err)-> res.sendEventError(err)
    )