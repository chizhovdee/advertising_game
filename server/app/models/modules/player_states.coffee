states = require('../states')

module.exports =
  _truckingState: null
  _advertisingState: null
  _propertiesState: null
  _routesState: null
  _transportState: null
  _factoriesState: null
  _materialsState: null
  _townMaterialsState: null
  _placesState: null

  stateByType: (type)->
    switch type
      when 'factories'
        @.factoriesState()
      when 'properties'
        @.propertiesState()
      when 'places'
        @.placesState()

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

  materialsState: ->
    return @_materialsState if @_materialsState?

    Object.defineProperty(@, '_materialsState'
      writable: false
      enumerable: true
      value: new states.MaterialsState(@)
    )

    @_materialsState

  townMaterialsState: ->
    return @_townMaterialsState if @_townMaterialsState?

    Object.defineProperty(@, '_townMaterialsState'
      writable: false
      enumerable: true
      value: new states.TownMaterialsState(@)
    )

    @_townMaterialsState

  placesState: ->
    return @_placesState if @_placesState?

    Object.defineProperty(@, '_placesState'
      writable: false
      enumerable: true
      value: new states.PlacesState(@)
    )

    @_placesState
