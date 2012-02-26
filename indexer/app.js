(function() {
  var done, ffprobe, fs, glob, music_directory, prober, sha1, _;

  ffprobe = require('node-ffprobe');

  glob = require("glob");

  _ = require("underscore");

  fs = require('fs');

  sha1 = require('sha1');

  music_directory = '/Volumes/Storage/Music';

  prober = function(files, metadata) {
    return ffprobe(files.shift(), function(data) {
      process.stdout.write('.');
      if (data.metadata) {
        metadata.push({
          id: sha1(data.file),
          artist: data.metadata['ARTIST'],
          album: data.metadata['ALBUM'],
          title: data.metadata['TITLE'],
          url: "/music" + (data.file.replace(music_directory, '').replace('.flac', ''))
        });
      }
      if (files.length > 0) {
        return prober(files, metadata);
      } else {
        return done(metadata);
      }
    });
  };

  done = function(metadata) {
    return fs.writeFile("../server/public/metadata.json", JSON.stringify(metadata), function(err) {
      if (err) console.log(err);
      return console.log("done");
    });
  };

  glob("" + music_directory + "/**/*.flac", function(er, files) {
    return prober(files, []);
  });

}).call(this);
