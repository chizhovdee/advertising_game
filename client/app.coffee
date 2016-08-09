require("./lib/lodash_mixin").register()
require("./populate_game_data") # генерируется автоматически при сборке
require('./lib/notify_styles')

request = require("./lib/request")
Player = require("./models").Player
PlayerState = require("./models").PlayerState
preloader = require("./lib/preloader")
signatureKeeper = require('./lib/signature_keeper')
layouts = require("./controllers/layouts")
HomePage = require('./controllers/pages').HomePage
modals = require('./controllers/modals')
ctx = require('./context')
Timer = require('./lib').Timer
displays = require('./utils').displays
render = require('./utils').render

# сначала грузиться манифест с помощью прелоадера
# затем загружается персонаж
# затем запускается главная сцена

class App
  character: null
  timers: null
  infoPopupDuration: _(5).seconds()

  constructor: ->
    @timers = []

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
    @playerState = PlayerState.create(response.states)

    ctx.set("player", @player)
    ctx.set('playerState', @playerState)

    new layouts.HeaderLayout(el: $("#application .header")).show()
    new layouts.SidebarLayout(el: $("#sidebar")).show()

    HomePage.show()

    @.checkPlayerStateStatus()

    @.setCommonTimers()

  onPlayerUpdated: (response)=>
    console.log 'onPlayerUpdated'
    console.log response

    @player.updateAttributes(response.player)
    @playerState.applyChangingOperations(response.state_operations)

    modals.NewLevelModal.show() if response.new_level

    @.setCommonTimers()

  setTranslations: ->
    I18n.defaultLocale = window.lng
    I18n.locale = window.lng
    #   :one  = 1, 21, 31, 41, 51, 61...
    #   :few  = 2-4, 22-24, 32-34...
    #   :many = 0, 5-20, 25-30, 35-40...
    #   :other = 1.31, 2.31, 5.31...
    I18n.pluralization['ru'] = (count)->
      if count == 0
        ['zero']
      else if count % 10 == 1 && count % 100 != 11
        ['one']
      else if [2, 3, 4].indexOf(count % 10) >= 0 && [12, 13, 14].indexOf(count % 100) < 0
        ['few']
      else if count % 10 == 0 || [5, 6, 7, 8, 9].indexOf(count % 10) >= 0 ||
              [11, 12, 13, 14].indexOf(count % 100) >= 0
        ['many']
      else
        ['other']

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

    displays.displayError(I18n.t('common.errors.server_error'))

  checkPlayerStateStatus: ->
    if _.find(@playerState.advertisingRecords(), (ad)-> !ad.isExpired() && ad.canOpenRoute())
      @.displayInfoPopup(render.renderTemplate('notifications/can_open_route'))

  setCommonTimers: ->
    @.setAdvertisingTimers()

  setAdvertisingTimers: ->
    advertising = _.sortBy(@playerState.advertisingRecords(), (ad)-> ad.actualNextRouteTimeLeft())

    ad = _.find(advertising, (ad)-> !ad.isExpired() && !ad.canOpenRoute())

    unless ad?
      @timers.advertisingNextRoute?.stop()

      return

    @timers.advertisingNextRoute ?= new Timer((timer)=>
      ad = @playerState.findAdvertisingRecord(timer.advertisingId)

      if ad? && !ad.isExpired()
        @.displayInfoPopup(render.renderTemplate('notifications/can_open_route'))

      @.setAdvertisingTimers()
    )

    @timers.advertisingNextRoute.advertisingId = ad.id

    @timers.advertisingNextRoute.start(ad.actualNextRouteTimeLeft())

  displayInfoPopup: (content)->
    @popups ?= []

    @popups.push ->
      displays.displayPopup(
        $("#right_notification"),
        content,
        position: "left top"
        className: "info"
        autoHide: true
        autoHideDelay: @infoPopupDuration
      )

    display = =>
      @curentPopup = @popups.shift()

      if @curentPopup?
        @curentPopup()

        setTimeout(
          => @curentPopup = null
          @infoPopupDuration
        )

    display() unless @curentPopup?

    @popupsInterval ?= Visibility.every(@infoPopupDuration, =>
      display()
    )

module.exports = App
