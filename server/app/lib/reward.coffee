# Rewards:
# - energy
# - health
# - basic_money
# - vip_money
# - experience

_ = require('lodash')

class Reward
  values: null
  player: null

  constructor: (@player, @resource)->
    @values = {}
    @triggers = {}

  on: (trigger)->
    if !trigger || trigger.trim().length == 0
      throw new Error("Argument Error: no correct trigger name for reward")

    @triggers[trigger] ?= new Reward()

  getOn: (trigger)->
    @triggers[trigger]

  applyOn: (trigger, reward, multiplier = 1)->
    @.getOn(trigger).apply(reward, multiplier)

  apply: (reward, multiplier = 1)->
    for key, value of @values
      switch key
        when 'basic_money'
          reward.giveBasicMoney(value * multiplier)
        when 'vip_money'
          reward.giveVipMoney(value * multiplier)
        when 'experience'
          reward.giveExperience(value * multiplier)
        when 'materials'
          for type, amount of value
            reward.giveMaterial(type, amount * multiplier)

  getValue: (key)->
    @values[key]

  # метод применяет награду к простым аттрибутам
  simpleAttribute: (attribute, value)->
    result = (
      switch attribute
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
        else
          0
    )

    @.push(attribute, result) if result != 0

  # give
  giveMaterial: (type, value)->
    throw new Error('resource is undefined') unless @resource?

    return if value < 0

    @player.materialsState().give(@resource, type, value)

    @.material(type, value)

  giveExperience: (value)->
    return if value < 0
    @.simpleAttribute('experience', value)

  giveBasicMoney: (value)->
    return if value < 0
    @.simpleAttribute('basic_money', value)

  giveVipMoney: (value)->
    return if value < 0
    @.simpleAttribute('vip_money', value)

  # take
  takeBasicMoney: (value)->
    return if value < 0
    @.simpleAttribute('basic_money', -value)

  takeVipMoney: (value)->
    return if value < 0
    @.simpleAttribute('vip_money', -value)

  takeMaterial: (type, value)->
    throw new Error('resource is undefined for take material in reward') unless @resource?

    return if value < 0

    source = @player.materialsState().getFor(@resource, type)

    value = source if value > source

    @player.materialsState().take(@resource, type, value)

    @.material(type, -value)

  basicMoney: (value)->
    @.push('basic_money', value)

  vipMoney: (value)->
    @.push('vip_money', value)

  experience: (value)->
    @.push('experience', value)

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
