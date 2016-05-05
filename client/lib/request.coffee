module.exports =
  one: (eventName, callback)->
    Spine.Events.one(eventName, callback)

  bind: (eventName, callback)->
    Spine.Events.bind(eventName, callback)

  unbind: (eventName, callback)->
    Spine.Events.unbind(eventName, callback)

  trigger: (eventName, data)->
    Spine.Events.trigger(eventName, data)

  send: (eventName, data)->
    if @[eventName]?
      @[eventName](data)
    else
      console.error 'Unknown event type:', eventName, data

  processResponse: (response)->
    @.trigger(res.event_type, res.data) for res in response

  prefixUrl: (url)->
    "/api/777/#{url}"

  ajax: (type, url, data)->
    $.ajax(
      type: type
      url: @.prefixUrl(url)
      data: data
      dataType: "json"
      success: (response)=>
        @.processResponse(response)

      error: (xhr, type)->
        console.error("Ajax error!", xhr, type)
    )

  get: (url, data)->
    @.ajax("GET", url, data)

  post: (url, data)->
    @.ajax("POST", url, data)

  put: (url, data)->
    @.ajax("PUT", url, data)

  delete: (url, data)->
    @.ajax("DELETE", url, data)

  loadGameData: ->
    @.get("game_data.json")

#  load_character_status: ->
#    @.get("characters/status.json")
#
#  load_shop: (data)->
#    @.get('shop.json', data)
#
#  buy_item: (data)->
#    @.post('buy_item.json', data)

  # staff
  hire_staff: (data)->
    @.post('/staff/hire.json', data)

  # properties
  load_properties: ->
    @.get('/properties')

  # trucking
  load_trucking: ->
    @.get('/trucking')

  # routes
  load_routes: ->
    @.get('/routes')

  create_trucking: (data)->
    @.post('/trucking/create', data)