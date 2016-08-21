gulp = require("gulp")
map     = require('map-stream')
yaml    = require('js-yaml')
gutil = require("gulp-util")
del = require('del')
_ = require("lodash")

serverAssetsDir = '../server/public/assets'

gulp.task('compile-locales', ->
  data = {
    ru: {}
    en: {}
  }
  del.sync("#{ serverAssetsDir }/locales*",force: true)

  gulp.src('./locales/**/*.yml').pipe(map((file,cb)->
      return cb(null, file) if file.isNull() # pass along
      return cb(new Error("Streaming not supported")) if file.isStream()

      lng = ""

      try
        json = yaml.load(String(file.contents.toString('utf8')))

        if json.ru
          lng = "ru";
        else if json.en
          lng = "en"
        else
          return cb(new Error("Language not supported"))

        _.merge(data[lng], json[lng])

      catch e
        console.log(e)
        console.log(json)

      file = new gutil.File(
        cwd: ""
        base: ""
        path: "locales_#{ lng }.json"
        contents: new Buffer(JSON.stringify(data[lng]))
      );

      cb(null, file)
  )).pipe(gulp.dest(serverAssetsDir))
)