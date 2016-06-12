BaseController = require('./base_controller')

modalList = []

class Modal extends BaseController
  className: 'modal'
  displayOverlay: true

  @show: (args...)->
    super

    @modal ?= new @()
    @modal.show(args...)

  @close: ->
    @.hide()

  @hide: ->
    super

    @modal?.hide()
    @modal = null

  constructor: ->
    super

    @overlay = $("<div class='modal_overlay'></div>") if @displayOverlay
    @applicationContainer = $("#application")
    @container = $("<div class='modal_container'></div>")

  bindEventListeners: ->
    super

    @el.on('click', '.close:not(.disabled)', @.onCloseClick)

  unbindEventListeners: ->
    super

    @el.off('click', '.close:not(.disabled)', @.onCloseClick)

  show: ->
    super

    if zIndex = @applicationContainer.find('.modal_overlay:last').css('z-index')
      zIndex = _.toInteger(zIndex)
      @overlay.css('z-index', zIndex + 1)
      @container.css('z-index', zIndex + 2)

    @el.hide().appendTo(@container)
    @container.appendTo(@applicationContainer)
    @overlay.appendTo(@applicationContainer) if @overlay?

    @el.fadeIn(100)

  close: ->
    @container.remove()
    @overlay.remove() if @overlay?

    @constructor.close()

  updateContent: (content)->
    @.html(@.renderTemplate('modal', content: content))

  onCloseClick: (e)=>
    $(e.currentTarget).addClass('disabled')

    @.close()

module.exports = Modal