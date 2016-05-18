module.exports =
  index: (req, res)->
    req.findCurrentPlayer()
    .then(->
      res.sendEvent("transport_loaded", (data)->

      )
    )
    .catch(
      (err)-> res.sendEventError(err)
    )
