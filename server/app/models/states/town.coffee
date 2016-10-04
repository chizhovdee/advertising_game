_ = require('lodash')
BaseState = require('./base')
TownLevel = require('../../game_data').TownLevel

class TownState extends BaseState
  # в базе данных не хранится состояние города, только отдельные поля для player
  defaultState: {}
  stateName: 'town'

  upgradingDuration: _.days(1)

  level: ->
    @_level ?= TownLevel.findByNumber(@player.town_level)

  collectBonus: ->
    @player.town_bonus_collected_at = new Date()

  upgradeTown: ->
    @player.town_level += 1
    @player.town_upgrade_at = new Date(Date.now() + @upgradingDuration)
    @player.town_bonus_collected_at = null # reset bonus

    @_level = null

  accelerateTown: ->
    @player.town_upgrade_at = new Date()

  isUpgrading: ->
    @player.town_upgrade_at > new Date()

  timeLeftToUpgrading: ->
    @player.town_upgrade_at.valueOf() - Date.now()

  canUpgrade: ->
    return false if _.isEmpty(@.level().materials)

    townResource = @player.placesState().resourceFor('town')

    for materialKey, maxCount of @.level().materials
      return false if maxCount > @player.materialsState().getFor(townResource, materialKey)

    true

  bonusBasicMoney: ->
    TownLevel.bonusBasicMoney +
    TownLevel.bonusBasicMoney * (@player.town_level - 1) *
    TownLevel.bonusFactor

  canCollectBonus: ->
    if @player.town_bonus_collected_at?
      (@player.town_bonus_collected_at.valueOf() + TownLevel.bonusDuration) - Date.now() <= 0

    else
      true

module.exports = TownState
