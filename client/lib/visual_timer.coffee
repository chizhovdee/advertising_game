Timer = require("./timer")
timeUtils = require("../utils").time

class VisualTimer extends Timer
  constructor: (@element, @finishCallback, @tickCallback)->

  setElement: (element)->
    @element?.empty()

    @element = element

  onTick: ->
    @.render()

    super

  onStop: ->
    @element.empty()

    super

  render: ->
    if @element.length > 0
      @element.text(
        timeUtils.formatTime(@.secondsToFinish())
      )
    else
      @.stop()


module.exports = VisualTimer