gulp = require("gulp")
rev = require('gulp-rev')
revdelOriginal = require('gulp-rev-delete-original')
revCss =require('gulp-rev-css-url')
browserify = require('browserify')
source = require('vinyl-source-stream')
fs = require("fs")
concat = require('gulp-concat')
buffer = require('vinyl-buffer')
file = require('gulp-file')
del = require('del')
crc = require('crc')
map = require('map-stream')
gutil = require("gulp-util")
gulpif = require('gulp-if')

serverAssetsDir = "../server/public/assets"

getRevision = (manifest)->
  crc.crc32(
    "#{ manifest['application.js'] }_#{ manifest['application.css'] }_#{ manifest['game_data.json'] }"
  )

tasks = [
  'prepare-scripts',
  'game_data_json',
  'compile-locales',
  'stylesheets',
  'copy-client-images',
  'server-images-timestamps'
]

revisionFile = 'revision.json'
revManifestFile = 'rev-manifest.json'

delRevisionFiles = ->
  del.sync(
    ["#{ serverAssetsDir }/#{ revManifestFile }", "#{ serverAssetsDir }/#{ revisionFile }"]
    force: true
  )

gulp.task("build", tasks, ->
  delRevisionFiles()

  manifest = {}

  fs.readdirSync(serverAssetsDir).forEach((name)->
    manifest[name] = name
  )

  revision = getRevision(manifest)

  file(revManifestFile, new Buffer(JSON.stringify(manifest)), { src: true })
  .pipe(gulp.dest(serverAssetsDir))
  .pipe(file(revisionFile,  new Buffer(JSON.stringify(revision: revision))))
  .pipe(gulp.dest(serverAssetsDir))
)


gulp.task("build:production", tasks, ->
  delRevisionFiles()

  gulp.src("#{ serverAssetsDir }/**")
  .pipe(gulpif('*.+(jpg|jpeg|ico|png|gif|svg)', rev()))
  .pipe(gulpif('*.+(css|js|json)', rev()))
  .pipe(revCss())
  .pipe(revdelOriginal())
  .pipe(gulp.dest(serverAssetsDir))
  .pipe(rev.manifest())
  .pipe(gulp.dest(serverAssetsDir))
  .pipe(map((file,cb)->
      return cb(null, file) if file.isNull() # pass along
      return cb(new Error("Streaming not supported")) if file.isStream()

      revision = getRevision(JSON.parse(file.contents.toString('utf8')))

      file = new gutil.File(
        cwd: ""
        base: ""
        path: revisionFile
        contents: new Buffer(JSON.stringify(revision: revision))
      );

      cb(null, file)
    ))
  .pipe(gulp.dest(serverAssetsDir))
)

gulp.task("prepare-scripts", [
  'coffee-compile',
  'eco-compile',
  'concat-vendors'
], ->
  del.sync(["#{ serverAssetsDir }/*.js"], force: true)

  vendors = fs.readFileSync("./build/vendors.js")

  browserify("./build/main.js", {debug: false})
  .bundle()
  .pipe(source("application.js"))
  .pipe(gulp.dest(serverAssetsDir))
  .pipe(file("vendor.js", vendors))
  .pipe(buffer())
  .pipe(concat("application.js"))
  .pipe(gulp.dest(serverAssetsDir))
)