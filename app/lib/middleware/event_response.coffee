_ = require('lodash')

class EventResponse
  events: null
  constructor: ->
    @events = []

  add: (eventType, callbackOrData)->
    data = {}

    if _.isFunction(callbackOrData)
      callbackOrData?(data)
    else
      data = callbackOrData

    @events.push(
      event_type: eventType
      data: data
    )

  all: ->
    @events

addEvent = (type, callbackOrData)->
  # @executorResult from addResult method
  @eventResponse.add(type, callbackOrData || @executorResult)

sendEvents = ->
  @.json(@eventResponse.all())

  null

sendEvent = (type, callback)->
  @.addEvent(type, callback)

  @.sendEvents()

  null

sendEventError = (error, type = '')->
  type = 'server_error' if type == ''

  console.error(error.stack)

  @addEvent(type, error: error.message)

  @.sendEvents()

  null

addEventProgress = ->
  return new Error('undefined current player for event progress') unless @currentPlayer?

  @addEvent('player_updated',
    player: @currentPlayer.toJSON()
    new_level: 'level' in @currentPlayer.changed
  )

sendEventsWithProgress = ->
  @.addEventProgress()

  @.sendEvents()

addEventWithResult = (type, result)->
  @.addResult(result)

  @.addEvent(type)

module.exports = (req, res, next)->
  res.eventResponse ?= new EventResponse()

  res.addEvent = addEvent

  res.sendEvents = sendEvents

  res.sendEvent = sendEvent

  res.sendEventError = sendEventError

  res.addEventProgress = addEventProgress

  res.sendEventsWithProgress = sendEventsWithProgress

  res.addEventWithResult = addEventWithResult

  next()
