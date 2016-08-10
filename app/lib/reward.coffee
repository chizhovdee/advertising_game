# Rewards:
# - energy
# - health
# - basic_money
# - vip_money
# - experience

_ = require('lodash')

class Reward
  @Item: null
  values: null
  player: null

  constructor: (@player = null)->
    @values = {}
    @triggers = {}

  on: (trigger)->
    if !trigger || trigger.trim().length == 0
      throw new Error("Argument Error: no correct trigger name for reward")

    @triggers[trigger] ?= new Reward()

  getOn: (trigger)->
    @triggers[trigger]

  applyOn: (trigger, reward)->
    @.getOn(trigger).apply(reward)

  apply: (reward)->
    for key, value of @values
      switch key
        when 'reputation'
          reward.addReputation(value)
        when 'basic_money'
          reward.addBasicMoney(value)
        when 'vip_money'
          reward.addVipMoney(value)
        when 'experience'
          reward.addExperience(value)
        when 'fuel'
          reward.addFuel(value)

  getValue: (key)->
    @values[key]

  # метод применяет награду к простым аттрибутам
  simpleAttribute: (attribute, value)->
    result = (
      switch attribute
        when 'reputation'
          oldValue = @player.reputation

          @player.reputation += value

          @player.reputation - oldValue

        when 'basic_money'
          if @player.basic_money + value < 0
            value = value - @player.basic_money

          @player.basic_money += value

          value

        when 'vip_money'
          if @player.vip_money + value < 0
            value = value - @player.vip_money

          @player.vip_money += value

          value

        when 'experience'
          @player.experience += value

          value

        when 'fuel'
          if @player['fuel'] + value < 0
            value = value - @player['fuel']

          @player['fuel'] += value

          value
        else
          0
    )

    @.push(attribute, result) if result != 0

  # add

  addExperience: (value)->
    return if value < 0
    @.simpleAttribute('experience', value)

  addReputation: (value)->
    return if value < 0
    @.simpleAttribute('reputation', value)

  addBasicMoney: (value)->
    return if value < 0
    @.simpleAttribute('basic_money', value)

  addVipMoney: (value)->
    return if value < 0
    @.simpleAttribute('vip_money', value)

  addFuel: (value)->
    return if value < 0
    @.simpleAttribute('fuel', value)

  # take
  takeBasicMoney: (value)->
    return if value < 0
    @.simpleAttribute('basic_money', -value)

  takeVipMoney: (value)->
    return if value < 0
    @.simpleAttribute('vip_money', -value)

  takeFuel: (value)->
    return if value < 0

    @.simpleAttribute('fuel', -value)

  reputation: (value)->
    @.push('reputation', value)

  basicMoney: (value)->
    @.push('basic_money', value)

  vipMoney: (value)->
    @.push('vip_money', value)

  experience: (value)->
    @.push('experience', value)

  fuel: (value)->
    @.push('fuel', value)

  push: (key, value)->
    if @values[key]
      @values[key] += value
    else
      @values[key] = value

  toJSON: ->
    if !_.isEmpty(@triggers)
      @triggers
    else
      @values

module.exports = Reward
