_ = require("lodash")
Base = require('./base')

class Player extends Base
  @include require('./modules/player_experience')
  @include require('./modules/player_states')

  DEFAULT_DB_ATTRIBUTES = {
    # account attributes
    level: 1
    town_level: 1

    social_id: null
    session_key: null
    session_secret_key: null
    installed: false
    last_visited_at: null
    locale: 'ru'

    # game attributes
    basic_money: 5000
    vip_money: 10
    experience: 0
    reputation: 0
    fuel: 100
  }

  @stateFields: [
    'trucking', 'advertising', 'properties', 'routes',
    'transport', 'factories', 'materials', 'townMaterials'
  ]

  @default: ->
    new @(DEFAULT_DB_ATTRIBUTES)

  insert: ->
    @last_visited_at = new Date()

    super

  checkProgress: ->
    console.log 'checkProgress'
    if @.levelByCurrentExperience() > @level
      @level += 1

  stateOperations: ->
    result = {}

    for field in Player.stateFields
      operations = @["#{ field }State"]().changingOperations

      result[field] = operations if operations.length > 0

    result

  statesToJson: ->
    advertising: @.advertisingState().toJSON()
    properties: @.propertiesState().toJSON()
    routes: @.routesState().toJSON()
    transport: @.transportState().toJSON()
    trucking: @.truckingState().toJSON()
    factories: @.factoriesState().toJSON()
    materials: @.materialsState().toJSON()
    townMaterials: @.townMaterialsState().toJSON()

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
    locale: @locale
    town_level: @town_level
    town_bonus_collected_at: @town_bonus_collected_at?.valueOf()


module.exports = Player