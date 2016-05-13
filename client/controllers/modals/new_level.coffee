Modal = require("../modal")
Player = require('../../models').Player

class NewLevelModal extends Modal
  className: 'new_level modal'

  show: ->
    super

    changes = @player.changes()

    #@newPoints = changes.points[1] - changes.points[0]

    @.render()

  render: ->
    @updateContent(
      @.renderTemplate('new_level')
    )

  bindEventListeners: ->
    super

  unbindEventListeners: ->
    super

module.exports = NewLevelModal