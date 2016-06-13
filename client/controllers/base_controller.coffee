utils = require("../utils")
ctx = require('../context')
settings = require('../settings')

class BaseController extends Spine.Controller
  player: null
  settings: null

  @include utils.render
  @include utils.time
  @include utils.design
  @include utils.assets
  @include utils.pictures
  @include utils.displays

  @show: ->

  @hide: ->

  constructor: ->
    super

    @player = ctx.get('player')
    @settings = settings

  show: ->
    @.unbindEventListeners()
    @.bindEventListeners()

  hide: ->
    @.unbindEventListeners()

    @player = null
    @settings = null

    @el.remove()

  bindEventListeners: ->

  unbindEventListeners: ->

  renderPreloader: ->
    @html "<div class='loading'></div>"

module.exports = BaseController