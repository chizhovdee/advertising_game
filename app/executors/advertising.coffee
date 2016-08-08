_ = require('lodash')
lib = require('../lib')
Result = lib.Result
Reward = lib.Reward
Requirement = lib.Requirement

AdvertisingType = require('../game_data').AdvertisingType
PropertyType = require('../game_data').PropertyType

module.exports =
  createAdvertising: (player, data)->
    type = AdvertisingType.find(data.type)

    return new Result(
      error_code: Result.errors.dataNotFound
    ) unless type?

    status = data.status
    period = data.period
    period = _.first(AdvertisingType.periods) if period < _.first(AdvertisingType.periods)
    period = _.last(AdvertisingType.periods) if period > _.last(AdvertisingType.periods)

    return new Result(
      error_code: Result.errors.notCorrectData
    ) unless status in AdvertisingType.status

    return new Result(
      error_code: Result.errors.notReachedLevel
    ) if player.level < AdvertisingType.statusLevels[status]


    propertyType = PropertyType.find('command_center')
    property = player.propertiesState.findByTypeId(propertyType.id)

    # check capacity
    if player.advertisingState.count() >= propertyType.fullCapacityBy(property)
      return new Result(
        error_code: if property? then Result.errors.advertisingNoPlaces else Result.errors.advertisingNoPlacesBuild
      )

    requirement = new Requirement()
    requirement.basicMoney(type.price(status, period))

    unless requirement.isSatisfiedFor(player)
      return new Result(
        error_code: Result.errors.requirementsNotSatisfied
        data:
          requirement: requirement.unSatisfiedFor(player)
      )

    reward = new Reward(player)
    advertising = player.advertisingState.create(type, status, period)
    requirement.apply(reward)

    new Result(
      data:
        advertising_id: advertising.id
        reward: reward
    )

  deleteAdvertising: (player, advertisingId)->
    return new Result(
      error_code: Result.errors.dataNotFound
    ) unless player.advertisingState.findRecord(advertisingId)?

    player.advertisingState.deleteRecord(advertisingId)

    new Result()

  prolongAdvertising: (player, advertisingId, period)->
    advertising = player.advertisingState.findRecord(advertisingId)

    return new Result(
      error_code: Result.errors.dataNotFound
    ) unless advertising?

    advertisingType = AdvertisingType.find(advertising.typeId)

    period = _.first(AdvertisingType.periods) if period < _.first(AdvertisingType.periods)
    period = _.last(AdvertisingType.periods) if period > _.last(AdvertisingType.periods)

    resultDuration = player.advertisingState.expireTimeLeftFor(advertising.id) + _(period).days()

    return new Result(
      error_code: Result.errors.advertisingReachedMaxDuration
    ) if resultDuration > _(AdvertisingType.maxDuration).days()

    requirement = new Requirement()
    requirement.basicMoney(advertisingType.price(advertising.status, period))

    unless requirement.isSatisfiedFor(player)
      return new Result(
        error_code: Result.errors.requirementsNotSatisfied
        data:
          requirement: requirement.unSatisfiedFor(player)
      )

    reward = new Reward(player)
    player.advertisingState.prolong(advertising.id, period)
    requirement.apply(reward)

    new Result(
      data:
        advertising_id: advertising.id
        reward: reward
    )
