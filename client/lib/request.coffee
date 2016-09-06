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
    "/api/#{ window.assetsRevision.revision }/#{url}"

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

  ##################### requests #########################

  # trucking
  create_trucking: (data)->
    @.post('trucking/create', data)

  collect_trucking: (data)->
    @.put('trucking/collect', data)

  # properties
  create_property: (data)->
    @.post('properties/create', data)

  accelerate_property: (data)->
    @.put('properties/accelerate', data)

  upgrade_property: (data)->
    @.put('properties/upgrade', data)

  rent_out_property: (data)->
    @.put('properties/rent_out', data)

  property_collect_rent: (data)->
    @.put('properties/collect_rent', data)

  property_finish_rent: (data)->
    @.put('properties/finish_rent', data)


  # factories
  create_factory: (data)->
    @.post('factories/create', data)

  accelerate_factory: (data)->
    @.put('factories/accelerate', data)

  upgrade_factory: (data)->
    @.put('factories/upgrade', data)

  start_factory: (data)->
    @.put('factories/start', data)

  collect_factory: (data)->
    @.put('factories/collect', data)

  # advertising
  create_advertising: (data)->
    @.post('advertising/create', data)

  delete_advertising: (data)->
    @.delete('advertising/delete', data)

  prolong_advertising: (data)->
    @.put('advertising/prolong', data)

  # routes
  open_route: (data)->
    @.put('routes/open', data)

  load_routes: ->
    @.get('routes')

  # shop
  buy_transport: (data)->
    @.post('shop/buy_transport', data)

  buy_fuel: (data)->
    @.put('shop/buy_fuel', data)
