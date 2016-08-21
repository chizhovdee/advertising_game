Player = require('../models').Player

module.exports =
  index: (req, res)->
    res.locals.okSignedParams = req.okSignedParams
    res.locals.offlineSignedParams = req.offlineSignedParams

    res.locals.assetsRevision = req.assetsRevision
    res.locals.assetsManifest = req.assetsManifest

    res.render('index', title: 'Игра "Траснпортная компания"')

  gameData: (req, res)->
    req.findOrCreateCurrentPlayer()
    .then(->
      res.sendEvent("game_data_loaded", (data)->
        data.player = req.currentPlayer.toJSON()
        data.states = req.currentPlayer.statesToJson()
      )
    )
    .catch(
      (err)-> res.sendEventError(err)
    )