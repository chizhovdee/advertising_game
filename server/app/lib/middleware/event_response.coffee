_ = require('lodash')

class EventResponse
  @types:
    factories:
      create: 'factory_created'
      accelerate: 'factory_accelerated'
      upgrade: 'factory_upgraded'
      start: 'factory_started'

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
  if _.isArray(type)
    [controller, action] = type

    type = EventResponse.types[controller][action]

    throw new Error("Undefined event type for controller - #{ controller } and action - #{ action }") unless type?

  # @executorResult from addResult method
  @eventResponse.add(type, callbackOrData || @executorResult)

sendEvents = ->
  @.json(_.sortBy(@eventResponse.all(), (e)-> if e.event_type == 'player_updated' then 0 else 1))

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

addEventProgress = (player)->
  return new Error('undefined player for event progress') unless player?

  @addEvent('player_updated',
    player: player.toJSON()
    state_operations: player.stateOperations()
    new_level: 'level' in player.changed
  )

sendEventsWithProgress = (player)->
  @.addEventProgress(player)

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
