Modal = require("../modal")
Route = require('../../game_data').Route
Transport = require('../../game_data').Transport
request = require('../../lib').request

class TransportSelectionModal extends Modal
  className: 'transport_selection modal'

  show: ->
    super

    @.render()

  render: ->
    @updateContent(
      @.renderTemplate('transport/selection')
    )

  bindEventListeners: ->
    super

  unbindEventListeners: ->
    super


module.exports = TransportSelectionModal