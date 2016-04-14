Player = require('../models').Player

module.exports =
  index: (req, res)->
    res.locals.okSignedParams = req.okSignedParams
    res.locals.offlineSignedParams = req.offlineSignedParams
    res.render('index', title: 'Игра "Траснпортная компания"')

  gameData: (req, res)->
    req.findOrCreateCurrentPlayer()
    .then(->
      res.sendEvent("game_data_loaded", (data)->
        data.player = req.currentPlayer.toJSON()
      )
    )
    .catch(
      (err)-> res.sendEventError(err)
    )