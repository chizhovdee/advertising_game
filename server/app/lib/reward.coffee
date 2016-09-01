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
          reward.giveReputation(value)
        when 'basic_money'
          reward.giveBasicMoney(value)
        when 'vip_money'
          reward.giveVipMoney(value)
        when 'experience'
          reward.giveExperience(value)
        when 'fuel'
          reward.giveFuel(value)
        when 'materials'
          for type, amount of value
            reward.giveMaterial(type, amount)

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

  # give
  giveMaterial: (type, value)->
    return if value < 0

    @player.materialsState().give(type, value)

    @.material(type, value)

  giveExperience: (value)->
    return if value < 0
    @.simpleAttribute('experience', value)

  giveReputation: (value)->
    return if value < 0
    @.simpleAttribute('reputation', value)

  giveBasicMoney: (value)->
    return if value < 0
    @.simpleAttribute('basic_money', value)

  giveVipMoney: (value)->
    return if value < 0
    @.simpleAttribute('vip_money', value)

  giveFuel: (value)->
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

  takeMaterial: (type, value)->
    return if value < 0

    source = @player.materialsState().get(type)

    value = source if value > source

    @player.materialsState().take(type, value)

    @.material(type, value)

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

  material: (type, value)->
    @values.materials ?= {}
    @values.materials[type] ?= 0
    @values.materials[type] += value

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
