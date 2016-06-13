module.exports =
  displayResult: (element, data = {}, options = {})->
    (element || $('#application .notification')).notify(
      {
        content: @.renderTemplate('notifications/result', data)
      },
      _.assignIn({
        raw: true
        style: 'game'
        className: 'black'
        showAnimation: 'fadeIn'
        hideAnimation: 'fadeOut'
        showDuration: 200
        hideDuration: 200
        alterClassName: 'result_notification'
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
    $('#application .notification').notify(
      {content: message}
      {
        elementPosition: 'top center'
        arrowShow: false
        style: 'game'
        className: 'error'
        showDuration: 200
      }
    )

  displaySuccess: (message)->
    $('#application .notification').notify(
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
      }, options)
    )

  displayConfirm: (element, options = {})->
    @.displayPopup(element,
      @.renderTemplate("confirm",
        button: options.button
      )

      position: options.position || 'left bottom'
      alterClassName: 'confirm_popup'
    )