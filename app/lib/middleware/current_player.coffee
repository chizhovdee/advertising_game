Player = require('../../models').Player

findOrCreateCurrentPlayer = ->
  self = @

  Player.fetchForRead(self.db, social_id: self.currentSocialUser.uid, 'oneOrNone')
  .then((data)->
    if data
      self.currentPlayer = new Player(data)

    else
      player = Player.default()

      player.social_id = self.currentSocialUser.uid
      player.installed = self.currentSocialUser?.isAuthenticated()
      player.session_key = self.currentSocialUser.session_key
      player.session_secret_key = self.currentSocialUser.session_secret_key

      self.db.tx((t)->
        player.insert(t)
      )
  )
  .then((data)->
    if self.currentPlayer
      self.currentPlayer

    else if data
      self.currentPlayer = new Player(data)
  )

setCurrentPlayer = (data)->
  @currentPlayer = new Player(data)

currentPlayerForUpdate = (db)->
  Player.fetchForUpdate(db, social_id: @currentSocialUser.uid)

currentPlayerForRead = (db)->
  Player.fetchForRead(db, social_id: @currentSocialUser.uid)

module.exports = (req, res, next)->
# TODO определение платформы здесь

  req.currentSocialUser = req.currentOkUser || req.currentOfflineUser

  req.currentPlayer = null

  req.findOrCreateCurrentPlayer = findOrCreateCurrentPlayer

  req.setCurrentPlayer = setCurrentPlayer

  req.currentPlayerForUpdate = currentPlayerForUpdate
  req.currentPlayerForRead = currentPlayerForRead

  if req.currentSocialUser?.isAuthenticated()
    next()

  else
    res.sendEvent('not_authenticated')