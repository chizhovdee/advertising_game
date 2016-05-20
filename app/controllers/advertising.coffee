module.exports =
  index: (req, res)->
    req.findCurrentPlayer()
    .then(->
      res.sendEvent("advertising_loaded", (data)->
        data.advertising = []
      )
    )
    .catch(
      (err)-> res.sendEventError(err)
    )
