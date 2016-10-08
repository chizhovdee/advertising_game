Page = require("../page")
TransportListLayout = require('../layouts/transport_list')

class TransportPage extends Page
  className: "transport page"

  show: ->
    super

    @.render()

    @transportList = new TransportListLayout(el: "#transport")
    @transportList.show()

  hide: ->
    @transportList.hide()

    super

  render: ->
    @html(@.renderTemplate("transport/index"))


module.exports = TransportPage
