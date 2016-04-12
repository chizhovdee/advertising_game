assets = require('./assets')
gameData = require('../game_data')
#Item = require('../game_data').Item
EmployeeType = gameData.EmployeeType

module.exports =
  itemPictureUrl: (item, format = 'large')->
    unless item instanceof Item
     item = Item.find(item)

    unless format in ['large', 'medium', 'icon']
      throw new Error('format for item picture url not correct')

    assets.assetsPath("images/items/#{ format }/#{ item.key }.jpg")

  itemPicture: (item, format = 'large')->
    unless item instanceof Item
      item = Item.find(item)

    title = "title=#{item.name()}"

    "<img src='#{ @.itemPictureUrl(item, format) }' #{title} />"

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