BaseController = require("./base_controller")

class InnerPage extends BaseController
  show: (container)->
    super

    container.append(@el)

module.exports = InnerPage
