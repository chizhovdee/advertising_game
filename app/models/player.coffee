_ = require("lodash")
Base = require('./base')
states = require('./states')

class Player extends Base
  @include require('./modules/player_experience')

  DEFAULT_DB_ATTRIBUTES = {
    # account attributes
    level: 1
    social_id: null
    session_key: null
    session_secret_key: null
    installed: false
    last_visited_at: null

    # game attributes
    basic_money: 5000
    vip_money: 10
    experience: 0
    reputation: 0
    fuel: 100
  }

  @stateFields: [
    'trucking', 'advertising', 'properties', 'routes', 'transport'
  ]

  # define in defineStates()
  truckingState: null
  advertisingState: null
  propertiesState: null
  routesState: null
  transportState: null

  @default: ->
    new @(DEFAULT_DB_ATTRIBUTES)

  constructor: ->
    super

    @.defineStates()

  insert: ->
    @last_visited_at = new Date()

    super

  checkProgress: ->
    console.log 'checkProgress'
    if @.levelByCurrentExperience() > @level
      @level += 1

  defineStates: ->
    for field in Player.stateFields
      switch field
        when 'trucking'
          Object.defineProperty(@, 'truckingState'
            writable: false
            enumerable: true
            value: new states.TruckingState(@)
          )
        when 'advertising'
          Object.defineProperty(@, 'advertisingState'
            writable: false
            enumerable: true
            value: new states.AdvertisingState(@)
          )
        when 'properties'
          Object.defineProperty(@, 'propertiesState'
            writable: false
            enumerable: true
            value: new states.PropertiesState(@)
          )
        when 'routes'
          Object.defineProperty(@, 'routesState'
            writable: false
            enumerable: true
            value: new states.RoutesState(@)
          )
        when 'transport'
          Object.defineProperty(@, 'transportState'
            writable: false
            enumerable: true
            value: new states.TransportState(@)
          )

  stateOperations: ->
    result = {}

    for field in Player.stateFields
      operations = @["#{ field }State"].changingOperations

      result[field] = operations if operations.length > 0

    result

  statesToJson: ->
    advertising: @advertisingState.toJSON()
    properties: @propertiesState.toJSON()
    routes: @routesState.toJSON()
    transport: @transportState.toJSON()
    trucking: @truckingState.toJSON()

  toJSON: ->
    id: @id
    level: @level
    experience: @experience
    basic_money: @basic_money
    vip_money: @vip_money
    reputation: @reputation
    fuel: @fuel
    experience_to_next_level: @.experienceToNextLevel()
    level_progress_percentage: @.levelProgressPercentage()


module.exports = Player