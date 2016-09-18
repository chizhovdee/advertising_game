assets = require('./assets')
gameData = require('../game_data')

TransportGroup = gameData.TransportGroup
TransportModel = gameData.TransportModel
PropertyType = gameData.PropertyType
FactoryType = gameData.FactoryType

module.exports =
  transportModelPictureUrl: (transportModel, format = 'large')->
    if transportModel.constructor?.name != 'TransportModel'
      transportModel = TransportModel.find(transportModel)

    unless format in ['large', 'medium', 'icon']
      throw new Error('format for transport model picture url not correct')

    assets.assetsPath("images/transport_models/#{ format }/#{ transportModel.key }.jpg")

  transportModelPicture: (transportModel, format = 'large')->
    if transportModel.constructor?.name != 'TransportModel'
      transportModel = TransportModel.find(transportModel)

    alt = "title='#{transportModel.name()}'"

    "<img src='#{ @.transportModelPictureUrl(transportModel, format) }' #{alt} />"

  transportGroupPictureUrl: (group, format = 'large')->
    if group.constructor?.name != 'TransportGroup'
      group = TransportGroup.find(group)

    unless format in ['large', 'medium', 'icon']
      throw new Error('format for transport group picture url not correct')

    assets.assetsPath("images/transport_groups/#{ format }/#{ type.key }.jpg")

  transportGroupPicture: (group, format = 'large')->
    if group.constructor?.name != 'TransportGroup'
      group = TransportGroup.find(group)

    alt = "title='#{group.name()}'"

    "<img src='#{ @.transportGroupPictureUrl(group, format) }' #{alt} />"

  advertisingPictureUrl: (advertisingType, format = 'large')->
    unless advertisingType.constructor?.name == 'AdvertisingType'
      advertisingType = AdvertisingType.find(advertisingType)

    unless format in ['large', 'medium', 'icon']
      throw new Error('format for advertising type picture url is not correct')

    assets.assetsPath("images/advertising_types/#{ format }/#{ advertisingType.key }.jpg")

  advertisingPicture: (advertisingType, format = 'large')->
    unless advertisingType.constructor?.name == 'AdvertisingType'
      advertisingType = AdvertisingType.find(advertisingType)

    title = "title=#{advertisingType.name()}"

    "<img src='#{ @.advertisingPictureUrl(advertisingType, format) }' #{title} />"

  advertisingStatusPictureUrl: (status, format = 'large')->
    unless format in ['large', 'medium', 'icon']
      throw new Error('format for advertising type picture url is not correct')

    assets.assetsPath("images/advertising_status/#{ format }/#{ status }.jpg")

  advertisingStatusPicture: (status, format = 'large')->
    "<img src='#{ @.advertisingStatusPictureUrl(status, format) }' />"

  propertyPictureUrl: (propertyType, format = 'large')->
    unless propertyType.constructor?.name == 'PropertyType'
      propertyType = PropertyType.find(propertyType)

    unless format in ['large', 'medium', 'icon']
      throw new Error('format for property picture url is not correct')

    assets.assetsPath("images/property_types/#{ format }/#{ propertyType.key }.jpg")

  propertyPicture: (propertyType, format = 'large')->
    unless propertyType.constructor?.name == 'PropertyType'
      propertyType = PropertyType.find(propertyType)

    title = "title='#{propertyType.name()}'"

    "<img src='#{ @.propertyPictureUrl(propertyType, format) }' #{title} />"

  factoryPictureUrl: (factoryType, format = 'large')->
    unless factoryType.constructor?.name == 'FactoryType'
      factoryType = FactoryType.find(factoryType)

    unless format in ['large', 'medium', 'icon']
      throw new Error('format for factory picture url is not correct')

    assets.assetsPath("images/factory_types/#{ format }/#{ factoryType.key }.jpg")

  factoryPicture: (factoryType, format = 'large')->
    unless factoryType.constructor?.name == 'FactoryType'
      factoryType = FactoryType.find(factoryType)

    title = "title='#{factoryType.name()}'"

    "<img src='#{ @.factoryPictureUrl(factoryType, format) }' #{title} />"

  objectPicture: (object)->
    switch object.constructor.name
      when 'FactoryType'
        @.factoryPicture(object)