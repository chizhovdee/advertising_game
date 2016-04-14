_ = require('lodash')

class BaseState
  defaultState: null
  stateName: null # должен совпадать с полем в бд таблице

  constructor: (@player)->
    throw new Error("player undefined") unless @player?
    throw new Error("stateName is undefined") unless @stateName?
    throw new Error("defaultState is undefined") unless @defaultState?

    state = (
      if @player[@stateName]
        _.cloneDeep(@player[@stateName])
      else
        _.defaultsDeep({}, @defaultState)
    )

    Object.defineProperty(@, 'state',
      value: state
      writable: false
      enumerable: true
    )

  update: ->
    @player[@stateName] = @state

module.exports = BaseState