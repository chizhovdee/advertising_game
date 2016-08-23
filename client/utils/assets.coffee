ctx = require('../context')

module.exports =
  assetsPath: (path)->
    path.slice(1, path.length) if path[0] == '/'

    parts = path.split('/')

    if 'images' == parts[0]
      "images/#{ parts.slice(1, parts.length).join('/') }?#{ ctx.get('images_timestamps')[parts[1]] }"
    else
      throw new Error('this directory for assets unknown. Please see client/utils/assets.coffee')
