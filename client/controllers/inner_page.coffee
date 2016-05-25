BaseController = require("./base_controller")

class InnerPage extends BaseController
  show: (container)->
    container.append(@el)

    super



module.exports = InnerPage
