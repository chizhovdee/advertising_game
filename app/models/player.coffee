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
    basic_money: 50
    vip_money: 1
    experience: 0
    reputation: 0
    fuel: 0
  }

  # define in defineStates()
  staffState: null

  @default: ->
    new @(DEFAULT_DB_ATTRIBUTES)

  constructor: ->
    super

    @.defineStates()

  insert: ->
    @last_visited_at = new Date()

    super

  checkProgress: ->
    if @.levelByCurrentExperience() > @level
      @level += 1

  defineStates: ->
    for field in @dbFields
      switch field
        when 'staff'
          Object.defineProperty(@, 'staffState'
            writable: false
            enumerate: true
            value: new states.StaffState(@)
          )
        when 'trucking'
          Object.defineProperty(@, 'truckingState'
            writable: false
            enumerate: true
            value: new states.TruckingState(@)
          )

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