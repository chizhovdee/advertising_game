Player = require('../models').Player

module.exports =
  index: (req, res)->
    res.locals.okSignedParams = req.okSignedParams
    res.locals.offlineSignedParams = req.offlineSignedParams
    res.render('index', title: 'Игра "Траснпортная компания"')

  gameData: (req, res)->
    req.findOrCreateCurrentPlayer()
    .then((data)->
      player = new Player(data)

      res.sendEvent("game_data_loaded", (data)->
        data.player = player.toJSON()
      )
    )
    .catch(
      (err)-> res.sendEventError(err)
    )