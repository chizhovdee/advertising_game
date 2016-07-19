module.exports =
  progressBar: (value, label = null)->
    labelStr = ""
    labelStr += "<div class='label'>#{label}</div>" if label

    """
    #{labelStr}
    <div class="progress_bar">
        <div class="percentage" style="width: #{ value }%"></div>
    </div>"""

  rawFormatNumber: (number, spacer = '&thinsp;')->
    "#{number}".replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1#{ spacer }")

  formatNumber: (number)->
    @safe @rawFormatNumber(number)

  transportGoodNames: (transport, length = 25)->
    goodNames = transport.goodNames()

    return goodNames if goodNames.length <= length

    str = _.truncate(transport.goodNames(), 'length': length, 'separator': /,? +/)
    str += " <span class='more_goods' data-transport-id='#{ transport.id }'>#{I18n.t('common.more_details')}</span>"

    str
