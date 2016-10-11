module.exports =
  displayResult: (element, result, options = {})->
    data = {}

    data.title = options.title
    data.reward = result.data?.reward
    data.requirement = result.data?.requirement

    if result.is_error
      data.type = 'failure'
      data.title ?= I18n.t("common.errors.#{ result.error_code }", options.errorArgs)
    else
      data.type = 'success'
      data.title = I18n.t("common.title_success_long") unless element?

    if data.title?.length > 50
      data.message = data.title
      data.title = null

    (element || $('#left_notification')).notify(
      {
        content: @.renderTemplate('notifications/result', data)
      },
      _.assignIn({
        raw: true
        style: 'game'
        className: 'black result_notification'
        showAnimation: 'fadeIn'
        hideAnimation: 'fadeOut'
        showDuration: 300
        hideDuration: 300
        autoHideDelay: _(5).seconds()
        arrowColor: "#333"
        position: (options.position || 'right top')
      }, options)
    )

  displayReward: (element, reward, options = {})->
    element.notify(
      {
        content: @.renderTemplate('notifications/reward', reward: reward)
      },
      _.assignIn({
        raw: true
        style: 'game'
        className: 'black'
        showAnimation: 'fadeIn'
        hideAnimation: 'fadeOut'
        showDuration: 200
        hideDuration: 200
      }, options)
    )

  displayError: (message)->
    $('#left_notification').notify(
      {content: message}
      {
        position: 'right top'
        style: 'game'
        className: 'error'
        showDuration: 200
        hideDuration: 200
        showAnimation: 'fadeIn'
        hideAnimation: 'fadeOut'
      }
    )

  displaySuccess: (message)->
    $('#left_notification').notify(
      {content: message}
      {
        elementPosition: 'top center'
        arrowShow: false
        style: 'game'
        className: 'success'
        showDuration: 200
        autoHideDelay: _(10).seconds()
      }
    )

  displayPopup: (element, content, options = {})->
    element.notify(
      {
        content: content
      },
      _.assignIn({
        raw: true
        style: 'game'
        className: "black  #{options.alterClassName}"
        autoHide: false
        showAnimation: 'fadeIn'
        hideAnimation: 'fadeOut'
        showDuration: 200
        hideDuration: 200
        arrowColor: "#333"
      }, options)
    )

  displayConfirm: (element, options = {})->
    @.displayPopup(element,
      @.renderTemplate("confirm",
        button: options.button
        message: options.message
      )
      ,
      position: (options.position || 'left bottom')
      alterClassName: 'confirm_popup'
    )