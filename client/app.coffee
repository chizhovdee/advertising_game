require("./lib/lodash_mixin").register()
require("./populate_game_data") # замещается автоматически при сборке
require('./lib/notify_styles')

request = require("./lib/request")
Player = require("./models").Player
preloader = require("./lib/preloader")
signatureKeeper = require('./lib/signature_keeper')
layouts = require("./controllers/layouts")
HomePage = require('./controllers/pages').HomePage
modals = require('./controllers/modals')
ctx = require('./context')

# сначала грузиться манифест с помощью прелоадера
# затем загружается персонаж
# затем запускается главная сцена

class App
  character: null

  constructor: ->
    @.setupEventListeners()

    preloader.loadManifest([
      {id: "locale", src: "locales/#{ window.lng }.json"}
    ])

  # все общие события для игры
  setupEventListeners: ->
    # события прелоадера
    preloader.on("complete", @.onManifestLoadComplete, this)
    preloader.on("progress", @.onManifestLoadProgress, this)

    # события транспорта
    request.one("game_data_loaded", @.onGameDataLoaded)
    request.bind('player_updated', @.onPlayerUpdated)
    request.bind('not_authenticated', @.onCharacterNotAuthorized)
    request.bind('server_error', @.onServerError)
    request.bind('not_reached_level', @.onNotReachedLevel)

    $.ajaxSetup(beforeSend: @.onAjaxBeforeSend)

    # события DOM

  onManifestLoadProgress: (e)->
    console.log "Total:", e.total, ", loaded:", e.loaded

  onManifestLoadComplete: ->
    console.log "onManifestLoadComplete"

    @.setTranslations()

    request.send("loadGameData")

  onGameDataLoaded: (response)=>
    console.log response

    @player = Player.create(response.player)

    ctx.set("player", @player)

    layouts.HeaderLayout.show(el: $("#application .header"))
    layouts.SidebarLayout.show(el: $("#sidebar"))

    HomePage.show()

  onPlayerUpdated: (response)=>
    console.log 'onPlayerUpdated'
    console.log response

    @player.updateAttributes(response.player)

    modals.NewLevelModal.show() if response.new_level

  setTranslations: ->
    I18n.defaultLocale = window.lng
    I18n.locale = window.lng
    I18n.translations ?= {}
    I18n.translations[window.lng] = preloader.getResult("locale")

  onCharacterNotAuthorized: ->
    alert('Персонаж не авторизован')

  onAjaxBeforeSend: (request)->
    signature = signatureKeeper.getSignature()
    signatureName = signatureKeeper.getSignatureName()

    request.setRequestHeader(signatureName.split('_').join('-'), signature)

  onServerError: (response)->
    console.error 'Server Error:', response.error

    $('#application .notification').notify(
      {content: I18n.t('common.errors.server_error')}
      {
        elementPosition: 'top center'
        arrowShow: false
        style: 'game'
        className: 'error'
        showDuration: 200
      }
    )

  onNotReachedLevel: ->
    $('#application .notification').notify(
      {content: I18n.t('common.errors.not_reached_level')}
      {
        elementPosition: 'top center'
        arrowShow: false
        className: 'error'
        style: 'game'
        showDuration: 200
      }
    )

module.exports = App
