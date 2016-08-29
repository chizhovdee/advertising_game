states = require('../states')

module.exports =
  _truckingState: null
  _advertisingState: null
  _propertiesState: null
  _routesState: null
  _transportState: null
  _factoriesState: null

  truckingState: ->
    return @_truckingState if @_truckingState?

    Object.defineProperty(@, '_truckingState'
      writable: false
      enumerable: true
      value: new states.TruckingState(@)
    )

    @_truckingState

  advertisingState: ->
    return @_advertisingState if @_advertisingState?

    Object.defineProperty(@, '_advertisingState'
      writable: false
      enumerable: true
      value: new states.AdvertisingState(@)
    )

    @_advertisingState

  propertiesState: ->
    return @_propertiesState if @_propertiesState?

    Object.defineProperty(@, '_propertiesState'
      writable: false
      enumerable: true
      value: new states.PropertiesState(@)
    )

    @_propertiesState

  factoriesState: ->
    return @_factoriesState if @_factoriesState?

    Object.defineProperty(@, '_factoriesState'
      writable: false
      enumerable: true
      value: new states.FactoriesState(@)
    )

    @_factoriesState

  routesState: ->
    return @_routesState if @_routesState?

    Object.defineProperty(@, '_routesState'
      writable: false
      enumerable: true
      value: new states.RoutesState(@)
    )

    @_routesState

  transportState: ->
    return @_transportState if @_transportState?

    Object.defineProperty(@, '_transportState'
      writable: false
      enumerable: true
      value: new states.TransportState(@)
    )

    @_transportState
