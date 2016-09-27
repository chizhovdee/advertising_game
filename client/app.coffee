require("./lib/lodash_mixin").register()
require('./lib/notify_styles')

request = require("./lib/request")
Player = require("./models").Player
PlayerState = require("./models").PlayerState
preloader = require("./lib/preloader")
signatureKeeper = require('./lib/signature_keeper')
layouts = require("./controllers/layouts")
TruckingPage = require('./controllers/pages').TruckingPage
modals = require('./controllers/modals')
ctx = require('./context')
Timer = require('./lib').Timer
displays = require('./utils').displays
render = require('./utils').render
gameData = require('./game_data')

# сначала грузиться ассеты с помощью прелоадера
# затем запускается главная сцен

class App
  character: null
  timers: null
  infoPopupDuration: _(5).seconds()

  constructor: ->
    @timers = []

    @.setupEventListeners()

    assets = []

    for key, value of window.assetsManifest
      key = key.split('.')[0]

      if key == 'application' ||
         (key.match(/locales/) && key != "locales_#{ window.currentPlayerData.locale }")
        continue

      assets.push {id: key, src: "assets/#{ value }"}

    preloader.loadManifest(assets)

  # все общие события для игры
  setupEventListeners: ->
    # события прелоадера
    preloader.on("complete", @.onManifestLoadComplete, this)
    preloader.on("progress", @.onManifestLoadProgress, this)

    request.bind('player_updated', @.onPlayerUpdated)
    request.bind('not_authenticated', @.onCharacterNotAuthorized)
    request.bind('server_error', @.onServerError)

    $.ajaxSetup(beforeSend: @.onAjaxBeforeSend)

  onManifestLoadProgress: (e)->
    console.log "Total:", e.total, ", loaded:", e.loaded

  onManifestLoadComplete: ->
    console.log "onManifestLoadComplete"

    @.populateData()

  populateData: ->
    ctx.set('images_timestamps', preloader.getResult('images_timestamps'))

    for key, value of preloader.getResult('game_data')
      if key == 'settings'
        ctx.set("settings", value)
      else
        gameData[_.upperFirst(_.camelCase(key))].populate(value)

    # определены в index.html
    @player = Player.create(window.currentPlayerData)
    console.log window.currentPlayerState
    @playerState = PlayerState.create(window.currentPlayerState)

    ctx.set("player", @player)
    ctx.set('playerState', @playerState)

    @.setTranslations()

    preloader.removeAll() # вычищаем прелоадер, освобождаем память

    @.show()

  show: ->
    new layouts.HeaderLayout(el: $("#application .header")).show()
    new layouts.SidebarLayout(el: $("#sidebar")).show()

    TruckingPage.show()

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
    I18n.defaultLocale = @player.locale
    I18n.locale = @player.locale
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
    I18n.translations[@player.locale] = preloader.getResult("locales_#{ @player.locale }")

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
