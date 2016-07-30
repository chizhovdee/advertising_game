lib = require('../lib')
Result = lib.Result
Reward = lib.Reward
Requirement = lib.Requirement

AdvertisingType = require('../game_data').AdvertisingType
PropertyType = require('../game_data').PropertyType

module.exports =
  createAdvertising: (player, data)->
    type = AdvertisingType.find(data.type)
    status = data.status
    period = data.period
    period = AdvertisingType.periods[0] if period < AdvertisingType.periods[0]

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
    player.advertisingState.create(type, status, period)
    requirement.apply(reward)

    new Result(
      data:
        reward: reward
    )
