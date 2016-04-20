Page = require("../page")
Pagination = require("../../lib").Pagination
modals = require('../modals')
request = require('../../lib/request')

class PropertiesPage extends Page
  className: "properties page"

  show: ->
    super

    @loading = true

    @.render()

    request.send('load_properties')

  render: ->
    if @loading
      @.renderPreloader()
    else
      @html(@.renderTemplate("properties/index"))

  bindEventListeners: ->
    super

    request.bind('properties_loaded', @.onDataLoaded)

  unbindEventListeners: ->
    super

    request.unbind('properties_loaded', @.onDataLoaded)

  onDataLoaded: (response)=>
    console.log response

    @loading = false

    @list = EmployeeType.all()
    @listPagination = new Pagination(PER_PAGE)
    @paginatedList = @listPagination.paginate(@list, initialize: true)

    @listPagination.setSwitches(@list)

    @.render()

module.exports = PropertiesPage
