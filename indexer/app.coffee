ffprobe = require 'node-ffprobe'
glob = require "glob"
_ = require "underscore"
fs = require 'fs'
sha1 = require 'sha1'

music_directory = '/Volumes/Storage/Music'

prober = (files, metadata) ->
  ffprobe files.shift(), (data) ->
    process.stdout.write '.'
    if data.metadata
      metadata.push {
        id: sha1(data.file),
        artist: data.metadata['ARTIST'],
        album: data.metadata['ALBUM'],
        title: data.metadata['TITLE'],
        url: "/music#{data.file.replace(music_directory, '').replace('.flac', '')}"
      }
    if files.length > 0
      prober files, metadata
    else
      done metadata

done = (metadata) ->
  fs.writeFile "../server/public/metadata.json", JSON.stringify(metadata), (err) ->
    console.log err if err
    console.log "done"


glob "#{music_directory}/**/*.flac", (er, files) ->
  prober files, []