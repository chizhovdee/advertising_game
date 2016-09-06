# Требования:
# - energy
# - health
# - basic_money
# - vip_money
# - materials

_ = require('lodash')

class Requirement
  values: null

  constructor: ->
    @values = {}
    @triggers = {}

  on: (trigger)->
    if !trigger || trigger.trim().length == 0
      throw new Error("Argument Error: no correct trigger name for requirement")

    @triggers[trigger] ?= new Requirement()

  getOn: (trigger)->
    @triggers[trigger]

  getValue: (key)->
    @values[key]

  reputation: (value)->
    @.push('reputation', value)

  basicMoney: (value)->
    @.push('basic_money', value)

  vipMoney: (value)->
    @.push('vip_money', value)

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

  isSatisfiedFor: (player, multiplier = 1)->
    for key, value of @values
      if key == 'materials'
        for type, amount of value
          return false if amount * multiplier > player.materialsState().get(type)
      else
        return false if value * multiplier > player[key]

    true

  # reward is instance of Reward class
  applyOn: (trigger, reward, multiplier = 1)->
    @.getOn(trigger).apply(reward, multiplier)

  apply: (reward, multiplier = 1)->
    for key, value of @values
      switch key
        when 'basic_money'
          reward.takeBasicMoney(value * multiplier)

        when 'vip_money'
          reward.takeVipMoney(value * multiplier)

        when 'fuel'
          reward.takeFuel(value * multiplier)

        when 'materials'
          for type, amount of value
            reward.takeMaterial(type, amount * multiplier)

  unSatisfiedFor: (player, multiplier = 1)->
    result = {}

    for key, value of @values
      if key == 'materials'
        for type, amount of value
          amount *= multiplier

          continue if amount <= player.materialsState().get(type)

          result.materials ?= {}
          result.materials[type] = [amount, false]

      else
        value *= multiplier
        result[key] = [value, false] if value > player[key]

    result

  toJSON: ->
    if !_.isEmpty(@triggers)
      @triggers
    else
      @values

module.exports = Requirement
