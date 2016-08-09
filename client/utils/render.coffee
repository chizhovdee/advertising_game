JST = require("../JST").JST # генерируется автоматически при сборке

module.exports =
  renderTemplate: (name, args...)->
    JST[name](_.assignIn({}, @, args...))

  renderRequirements: (requirements, callback)->
    return if !requirements? || _.isEmpty(requirements)

    result = '<div class="requirements">'
    result += callback?(@safe @.renderTemplate("requirements", requirements: requirements))
    result += '</div>'

    @safe result

  renderRewards: (rewards, callback)->
    return if !rewards? || _.isEmpty(
      _.pickBy(rewards, (value)->
        if _.isObject(value)
          not _.isEmpty(_.pickBy(value, (_value)-> _value > 0))
        else
          value > 0
      )
    )

    result = '<div class="rewards">'
    result += callback?(@safe @.renderTemplate("rewards", rewards: rewards))
    result += '</div>'

    @safe result

  renderSpendings: (rewards, callback)->
    return if !rewards? || _.isEmpty(
      _.pickBy(rewards, (value)->
        if _.isObject(value)
          not _.isEmpty(_.pickBy(value, (_value)-> _value < 0))
        else
          value < 0
      )
    )

    result = '<div class="spendings">'
    result += callback?(@safe @.renderTemplate("spendings", rewards: rewards))
    result += '</div>'

    @safe result

  renderTimer: (message, options = {})->
    className = if options.className? then options.className else ''
    hintPosition = if options.hintPosition? then options.hintPosition else 'bottom'

    if message?
      hint = "hint--#{ hintPosition } hint--no-animate"
      dataHint = "data-hint='#{ message }'"
    else
      hint = ""
      dataHint = ""

    label = if options.label? then "<span class='label'>#{ options.label }</span>" else ''

    """<div class="timer #{ className } #{ hint }" #{ dataHint }>
          #{ label }
          <span class="time-icon"></span>
          <span class="value"></span>
        </div>"""