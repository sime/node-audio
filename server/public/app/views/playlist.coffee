class app.views.Playlist extends Backbone.View
  tagName: 'div'
  id: 'playlist'

  events:
    "click .next":  "next"
    "click .prev":  "prev"
    "click .play":  "play"
    "click .stop":  "stop"

  next: (event) ->
    app.playlist.next()
    @play()

  prev: (event) ->
    app.playlist.prev()
    @play()

  play: (event) =>
    @stop()
    @audio = new buzz.sound app.playlist.current().get('url'), formats: ["mp3"]
    that = @
    @audio.play().bind "timeupdate", () ->
      if @isEnded() || @getTime() > 9000000000000 #9223372013568
        that.next()
      else
        timer = buzz.toTimer @getTime()
        $('.timer', that.el).html timer

    @render()

  stop: ->
    @audio.stop() if @audio
    @audio = undefined
    @render()


  addedToPlaylist: =>
    @play() unless @audio

  initialize: ->
    app.playlist.on "add", @addedToPlaylist

  render: =>
    @$el.html _.template @template, track: app.playlist.current(), audio: @audio

  template: """
    <div class="controls">
      <i class="prev icon-step-backward icon-white"></i>

      <% if(audio) { %>
        <i class="stop icon-stop icon-white"></i>
      <% } else { %>
        <i class="play icon-play icon-white"></i>
      <% } %>

      <i class="next icon-step-forward icon-white"></i>
    </div>

    <span class="current">
      <%= track.get('title') %> <span>/</span>
      <%= track.get('album') %> <span>/</span>
      <%= track.get('artist') %> <span>/</span>
      <span class="timer">00:00</span>
    </span>
  """