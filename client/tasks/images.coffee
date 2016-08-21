gulp = require('gulp')
del = require('del')
recursive = require('recursive-readdir')
fs = require('fs')

serverAssetsDir = '../server/public/assets'

gulp.task('copy-client-images', ->
  del.sync(["#{ serverAssetsDir }/**/*.+(jpg|jpeg|ico|png|gif|svg)"], force: true)

  gulp.src('./images/**')
  .pipe(gulp.dest(serverAssetsDir))
)

gulp.task('server-images-timestamps', (cb)->
  del.sync("#{ serverAssetsDir }/images_timestamps*",force: true)

  imagesTimestamps = {}

  recursive('../server/public/images/', (err, files)->
    throw new Error(err) if err?

    for file in files
      baseDirName = file.split('/')[4]

      timeStamp = Math.floor(fs.statSync(file).mtime.valueOf() / 1000)

      if !imagesTimestamps[baseDirName]? || imagesTimestamps[baseDirName] < timeStamp
        imagesTimestamps[baseDirName] = timeStamp

    fs.mkdir('../server/public/assets', ->
      fs.writeFileSync("../server/public/assets/images_timestamps.json",
        new Buffer(JSON.stringify(imagesTimestamps))
      )
    )

    cb?()
  )
)