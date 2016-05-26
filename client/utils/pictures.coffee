assets = require('./assets')
gameData = require('../game_data')
Transport = require('../game_data').Transport
EmployeeType = gameData.EmployeeType
AdvertisingType = gameData.AdvertisingType
PropertyType = gameData.PropertyType

module.exports =
#  transportPictureUrl: (transport, format = 'large')->
#    unless transport instanceof Transport
#      transport = Transport.find(transport)
#
#    unless format in ['large', 'medium', 'icon']
#      throw new Error('format for item picture url not correct')
#
#    assets.assetsPath("images/transport/#{ format }/#{ transport.key }.jpg")
#
#  transportPicture: (transport, format = 'large')->
#    unless transport instanceof Transport
#      transport = Transport.find(transport)
#
#    alt = "alt='#{transport.name()}'"
#
#    "<img src='#{ @.transportPictureUrl(transport, format) }' #{alt} />"
#
#  employeeTypePictureUrl: (type, format = 'large')->
#    unless type instanceof EmployeeType
#      type = EmployeeType.find(type)
#
#    unless format in ['large', 'medium', 'icon']
#      throw new Error('format for item picture url not correct')
#
#    assets.assetsPath("images/employee_types/#{ format }/#{ type.key }.jpg")
#
#  employeeTypePicture: (type, format = 'large')->
#    unless type instanceof EmployeeType
#      type = EmployeeType.find(type)
#
#    title = "title=#{type.name()}"
#
#    "<img src='#{ @.employeeTypePictureUrl(type, format) }' #{title} />"

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

  propertyPictureUrl: (resource, format = 'large')->
    unless resource.constructor?.name == 'PropertyType'
      resource = PropertyType.find(resource)

    unless format in ['large', 'medium', 'icon']
      throw new Error('format for property picture url is not correct')

    assets.assetsPath("images/property_types/#{ format }/#{ resource.key }.jpg")

  propertyPicture: (resource, format = 'large')->
    unless resource.constructor?.name == 'PropertyType'
      resource = PropertyType.find(resource)

    title = "title=#{resource.name()}"

    "<img src='#{ @.propertyPictureUrl(resource, format) }' #{title} />"