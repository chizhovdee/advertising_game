assets = require('./assets')
gameData = require('../game_data')
Transport = gameData.Transport
TransportType = gameData.TransportType
EmployeeType = gameData.EmployeeType
AdvertisingType = gameData.AdvertisingType
PropertyType = gameData.PropertyType

module.exports =
  transportPictureUrl: (transport, format = 'large')->
    unless transport instanceof Transport
      transport = Transport.find(transport)

    unless format in ['large', 'medium', 'icon']
      throw new Error('format for transport picture url not correct')

    assets.assetsPath("images/transport/#{ format }/#{ transport.key }.jpg")

  transportPicture: (transport, format = 'large')->
    unless transport instanceof Transport
      transport = Transport.find(transport)

    alt = "title='#{transport.name()}'"

    "<img src='#{ @.transportPictureUrl(transport, format) }' #{alt} />"

  transportTypePictureUrl: (type, format = 'large')->
    unless type instanceof TransportType
      type = TransportType.find(type)

    unless format in ['large', 'medium', 'icon']
      throw new Error('format for transport type picture url not correct')

    assets.assetsPath("images/transport_types/#{ format }/#{ type.key }.jpg")

  transportTypePicture: (type, format = 'large')->
    unless type instanceof TransportType
      type = TransportType.find(type)

    alt = "title='#{type.name()}'"

    "<img src='#{ @.transportTypePictureUrl(type, format) }' #{alt} />"

  advertisingPictureUrl: (resource, format = 'large')->
    unless resource.constructor?.name == 'AdvertisingType'
      resource = AdvertisingType.find(resource)

    unless format in ['large', 'medium', 'icon']
      throw new Error('format for advertising type picture url is not correct')

    assets.assetsPath("images/advertising_types/#{ format }/#{ resource.key }.jpg")

  advertisingPicture: (resource, format = 'large')->
    unless resource.constructor?.name == 'AdvertisingType'
      resource = AdvertisingType.find(resource)

    title = "title=#{resource.name()}"

    "<img src='#{ @.advertisingPictureUrl(resource, format) }' #{title} />"

  advertisingStatusPictureUrl: (status, format = 'large')->
    unless format in ['large', 'medium', 'icon']
      throw new Error('format for advertising type picture url is not correct')

    assets.assetsPath("images/advertising_status/#{ format }/#{ status }.jpg")

  advertisingStatusPicture: (status, format = 'large')->
    "<img src='#{ @.advertisingStatusPictureUrl(status, format) }' />"

  propertyPictureUrl: (resource, format = 'large')->
    unless resource.constructor?.name == 'PropertyType'
      resource = PropertyType.find(resource)

    unless format in ['large', 'medium', 'icon']
      throw new Error('format for property picture url is not correct')

    assets.assetsPath("images/property_types/#{ format }/#{ resource.key }.jpg")

  propertyPicture: (resource, format = 'large')->
    unless resource.constructor?.name == 'PropertyType'
      resource = PropertyType.find(resource)

    title = "title='#{resource.name()}'"

    "<img src='#{ @.propertyPictureUrl(resource, format) }' #{title} />"
