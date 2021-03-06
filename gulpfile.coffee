# sudo mv /etc/apt/sources.list.d/ondrej-php5-* ~
# should be a rm but I am keeping it as a backup :)

# curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
# sudo apt-get install -y nodejs
# sudo npm install -g gulp
# sudo npm install
# sudo npm install natives

# cd /var/www/html/cron/hmp/gulp-wav-id3/
# npm install

# cd /var/www/html/cron/hmp/gulp-wav-id3 && gulp coffee && gulp write-wav-id3 --json "test-data-TSH_162_trk001.wav.json" --wav "test-data.wav" 2>&1
# mediainfo test-data.wav

# gulp coffee && gulp write-wav-id3 --json "/home/x/y.json" --wav "/home/x/y.wav"
# gulp coffee && gulp write-riff

# gulp coffee && gulp list-riff-wav
# gulp coffee && gulp list-riff-dist

gulp        = require 'gulp'
coffeelint  = require 'gulp-coffeelint'
coffee      = require 'gulp-coffee'
del         = require 'del'
watch       = require 'gulp-watch'

gulp.task 'coffeelint', ->
  gulp.src ['./*.coffee', './src/*.coffee']
    .pipe coffeelint './coffeelint.json'
    .pipe coffeelint.reporter()

gulp.task 'coffee', gulp.series ('coffeelint'), ->
  gulp.src ['./src/*.coffee']
    .pipe coffee()
    .pipe gulp.dest './lib'

gulp.task 'default', gulp.series ('coffee')

gulp.task 'watch', ->
  gulp.watch './**/*.coffee', ['default']

gulp.task 'clean', (cb) ->
  del ['./lib/*.js', './**/*~'], force: true, cb





####### TESTING #######
fs = require 'fs'
id3 = require './lib/gulp-wav-id3'

gulp.task 'write-wav-id3', ->
  jsonPath = undefined
  i = process.argv.indexOf '--json'
  if i < 0
    throw new Error "JSON path not specified."
  jsonPath = process.argv[i + 1]
  console.info 'jsonPath', jsonPath
  jsonContent = JSON.parse (fs.readFileSync jsonPath, 'utf8')
  # console.info 'jsonContent', jsonContent

  wavPath = undefined
  i = process.argv.indexOf '--wav'
  if i < 0
    throw new Error "WAV path not specified."
  wavPath = process.argv[i + 1]
  console.info 'wavPath', wavPath

  gulp.src wavPath
    .pipe id3 (file, chunks) ->
      jsonContent
    .pipe gulp.dest (f) -> f.base



gulp.task 'write-riff', ->
  gulp.src ["wav/**/*.wav"]
    .pipe id3 (file, chunks) ->
      APIC: '/mnt/s3temp/gulp-wav-id3/wav/apic.jpg'
      TIT2: 'Akira TIT2 408'
      TALB: 'Akira TALB 407'
      TCOM: 'Akira TCOM 231'
      TCON: 'Akira TCON 232'
      COMM: 'Industrial glitched-up dubstep with tough beats, clubby synths and vocal samples.'
    .pipe gulp.dest (f) -> f.base

gulp.task 'list-riff-wav', ->
  gulp.src ['wav/**/*.wav']
    .pipe id3 (file, chunks) ->
      console.info (chunk.id for chunk in chunks)
      # if return null or undefined, file will not be changed.
      undefined

gulp.task 'list-riff-dist', ->
  gulp.src ['dist/**/*.wav']
    .pipe id3 (file, chunks) ->
      console.info (chunk.id for chunk in chunks)
      # if return null or undefined, file will not be changed.
      undefined
