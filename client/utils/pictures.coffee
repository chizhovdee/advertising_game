assets = require('./assets')
gameData = require('../game_data')
Transport = require('../game_data').Transport
EmployeeType = gameData.EmployeeType

module.exports =
  transportPictureUrl: (transport, format = 'large')->
    unless transport instanceof Transport
      transport = Transport.find(transport)

    unless format in ['large', 'medium', 'icon']
      throw new Error('format for item picture url not correct')

    assets.assetsPath("images/transports/#{ format }/#{ transport.key }.jpg")

  transportPicture: (transport, format = 'large')->
    unless transport instanceof Transport
      transport = Transport.find(transport)

    alt = "alt='#{transport.name()}'"

    "<img src='#{ @.transportPictureUrl(transport, format) }' #{alt} />"

  employeeTypePictureUrl: (type, format = 'large')->
    unless type instanceof EmployeeType
      type = EmployeeType.find(type)

    unless format in ['large', 'medium', 'icon']
      throw new Error('format for item picture url not correct')

    assets.assetsPath("images/employee_types/#{ format }/#{ type.key }.jpg")

  employeeTypePicture: (type, format = 'large')->
    unless type instanceof EmployeeType
      type = EmployeeType.find(type)

    title = "title=#{type.name()}"

    "<img src='#{ @.employeeTypePictureUrl(type, format) }' #{title} />"