STORE = {}

module.exports =
  set: (key, value)->
    console.warn("Warning: key #{key} is exists") if STORE[key]?

    STORE[key] = value

  get: (key)->
    STORE[key]

  delete: (key)->
    delete STORE[key]