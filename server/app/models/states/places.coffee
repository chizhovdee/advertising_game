_ = require('lodash')
BaseState = require('./base')

class PlacesState extends BaseState
  # места не хранятся в базе
  defaultState: {
    town: {
      id: 'town'
      placeTypeKey: 'town'
    }
  }

  stateName: 'places'

module.exports = PlacesState

