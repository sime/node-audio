(function() {
  var app, express, ffmpeg, fs, music_directory, _;

  ffmpeg = require('fluent-ffmpeg');

  _ = require("underscore");

  fs = require('fs');

  express = require('express');

  music_directory = '/Volumes/Storage/Music';

  app = express.createServer();

  app.configure(function() {
    return app.use(express.static(__dirname + '/public'));
  });

  app.get('/music/*', function(req, res) {
    var file, path, proc;
    res.contentType('mp3');
    path = req.params[0].replace('.mp3', '');
    file = "" + music_directory + "/" + path + ".flac";
    return proc = new ffmpeg(file).toFormat('mp3').writeToStream(res, function(retcode, error) {
      return console.log("Converted: " + file);
    });
  });

  app.listen(9999);

}).call(this);
