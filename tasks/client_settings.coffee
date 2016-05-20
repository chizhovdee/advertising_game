gulp = require("gulp")
fs = require("fs")
ejs = require("ejs")

settings = require('../app/client_settings')

gulp.task("client-settings", ->
  tmpl = fs.readFileSync("./client/settings.ejs")

  result = ejs.render(tmpl.toString(), settings: settings)

  fs.mkdir('./build', ->
    fs.mkdir('./build/client', ->
      fs.writeFileSync("./build/client/settings.js", result)
    )
  )
)