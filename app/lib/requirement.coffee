# Требования:
# - energy
# - health
# - basic_money
# - vip_money

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

  push: (key, value)->
    if @values[key]
      @values[key] += value
    else
      @values[key] = value

  isSatisfiedFor: (player)->
    for key, value of @values
      switch key
        when 'reputation'
          return false if value > player.reputation

        when 'basic_money'
          return false if value > player.basic_money

        when 'vip_money'
          return false if value > player.vip_money

        when 'fuel'
          return false if value > player.fuel

    true

  # reward is instance of Reward class
  applyOn: (trigger, reward)->
    @.getOn(trigger).apply(reward)

  apply: (reward)->
    for key, value of @values
      switch key
        when 'basic_money'
          reward.takeBasicMoney(value)

        when 'vip_money'
          reward.takeVipMoney(value)

        when 'fuel'
          reward.takeFuel(value)

  unSatisfiedFor: (player)->
    result = {}

    for key, value of @values
      switch key
        when 'reputation'
          result[key] = [value, false] if value > player.reputation

        when 'basic_money'
          result[key] = [value, false] if value > player.basic_money

        when 'vip_money'
          result[key] = [value, false] if value > player.vip_money

        when 'fuel'
          result[key] = [value, false] if value > player.fuel

    result

  toJSON: ->
    if !_.isEmpty(@triggers)
      @triggers
    else
      @values

module.exports = Requirement
