Player = require('../models').Player

module.exports =
  index: (req, res)->
    req.findOrCreateCurrentPlayer()
    .then(->
      res.render('index',
        title: 'Игра "Траснпортная компания"'
        okSignedParams: req.okSignedParams
        offlineSignedParams: req.offlineSignedParams
        assetsRevision: req.assetsRevision
        assetsManifest: req.assetsManifest
        currentPlayer: req.currentPlayer
      )
    )
    .catch(
      (err)->
        console.error error.stack
        throw error
    )