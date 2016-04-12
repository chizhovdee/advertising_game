_ = require("lodash")
Base = require('./base')

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

  @default: ->
    new @(DEFAULT_DB_ATTRIBUTES)

  constructor: ->
    super

  insert: ->
    @last_visited_at = new Date()

    super

  checkProgress: ->
    if @.levelByCurrentExperience() > @level
      @level += 1
      @improvement_points += 15 # TODO balance
      @education_points += 5

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