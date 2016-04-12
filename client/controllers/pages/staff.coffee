Page = require("../page")
Pagination = require("../../lib").Pagination
modals = require('../modals')
request = require('../../lib/request')

class StaffPage extends Page
  className: "staff page"

  show: ->
    super

    @firstLoading = true

    # данные берутся из клиента
    @.onDataLoaded({})

    @.render()

  render: ->
    if @loading
      @.renderPreloader()
    else
      @html(@.renderTemplate("staff/index"))

  bindEventListeners: ->
    super

  unbindEventListeners: ->
    super

  onDataLoaded: (response)=>
    console.log response

    @loading = false

    @.render()

module.exports = StaffPage
