utils = require("../utils")
ctx = require('../context')

class BaseController extends Spine.Controller
  player: null

  @include utils.render
  @include utils.time
  @include utils.design
  @include utils.assets
  @include utils.pictures

  @show: ->

  @hide: ->

  constructor: ->
    super

    @player = ctx.get('player')

  show: ->
    @.unbindEventListeners()
    @.bindEventListeners()

  hide: ->
    @.unbindEventListeners()

    @el.remove()

  bindEventListeners: ->

  unbindEventListeners: ->

  renderPreloader: ->
    @html "<div class='loading'></div>"

module.exports = BaseController