class Result
  @errors:
    requirementsNotSatisfied: 'requirements_not_satisfied'
    notReachedLevel: 'not_reached_level'
    dataNotFound: 'data_not_found'
    notCorrectData: 'not_correct_data'

    propertyIsBuilt: "property_is_built"
    propertyIsBuilding: "property_is_building"
    propertyIsUpgrading: "property_is_upgrading"
    propertyRentOutNotAvailable: "property_rent_out_not_available"
    propertyIsRented: "property_is_rented"
    propertyIsNotRented: "property_is_not_rented"
    propertyRentNotFinished: "property_rent_not_finished"
    noFreePlaces: "no_free_places"

    advertisingNoPlaces: "advertising_no_places"
    advertisingNoPlacesBuild: 'advertising_no_places_build'

  errorCode: null
  data: null
  reload: false

  constructor: (options = {})->
    @errorCode = options.error_code
    @data = options.data
    @reload = options.reload || false

  setErrorCode: (code)->
    @errorCode = code

  setData: (data)->
    @data = data

  isError: ->
    @errorCode?

  toJSON: ->
    {
      is_error: @.isError()
      error_code: @errorCode
      data: @data
      reload: @reload
    }

module.exports = Result