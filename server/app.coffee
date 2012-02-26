ffmpeg = require 'fluent-ffmpeg'
_ = require "underscore"
fs = require 'fs'
express = require 'express'


music_directory = '/Volumes/Storage/Music'
app = express.createServer()
app.configure -> app.use express.static(__dirname + '/public')


app.get '/music/*', (req, res) ->
  res.contentType 'mp3'
  path = req.params[0].replace '.mp3', ''
  file = "#{music_directory}/#{path}.flac"
  proc = new ffmpeg(file).toFormat('mp3').writeToStream res, (retcode, error) ->
    console.log "Converted: #{file}"


#{"artist":"test1","album":"test1","title":"test1","url":"/music/test"},
#{"artist":"test2","album":"test2","title":"test2","url":"/music/test"},
#{"artist":"test3","album":"test3","title":"test3","url":"/music/test"},

app.listen 9999