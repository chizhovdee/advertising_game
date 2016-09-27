module.exports =
  formatTime: (value)->
    result = ""

    return result unless value > 0

    days    = Math.floor(value / 86400)
    hours   = Math.floor((value - days * 86400) / 3600)
    minutes = Math.floor((value - days * 86400 - hours * 3600) / 60)
    seconds = value - days * 86400 - hours * 3600 - minutes * 60

    if days > 0
      result = I18n.t('common.timer.days', count: days)

    if hours > 0
      result = "#{ result } #{ hours }:"

    if minutes < 10
      result = "#{ result }0#{ minutes }"
    else
      result = "#{ result }#{ minutes }"

    if seconds < 10
      result = "#{ result }:0#{ seconds }"
    else
      result = "#{ result }:#{ seconds }"

    result

  displayTime: (value, options = {})->
    unless value > 0
      return (
        if options.empty_time
          '00:00'
        else
          ''
      )

    value = value / 1000

    days    = Math.floor(value / 86400)
    hours   = Math.floor((value - days * 86400) / 3600)
    minutes = Math.floor((value - days * 86400 - hours * 3600) / 60)
    seconds = Math.floor(value - days * 86400 - hours * 3600 - minutes * 60)

    result = []

    if days > 0
      result.push I18n.t('common.timer.days', count: days)
    if hours > 0
      result.push I18n.t('common.timer.hours', count: hours)
    if minutes > 0 && days <= 0
      result.push I18n.t('common.timer.minutes', count: minutes)
    if !options.without_seconds && seconds > 0 && days <= 0
      result.push I18n.t('common.timer.seconds', count: seconds)

    result.join(' ')