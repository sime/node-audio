class app.views.Playlist extends Backbone.View
  tagName: 'div'
  id: 'playlist'

  events:
    "click .next":              "next"
    "click .prev":              "prev"
    "click .play":              "play"
    "click .stop":              "stop"
    "click .clear_playlist":    "clearPlaylist"
    "click .set_current_track": "setCurrentTrack"

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

  stop: (event) ->
    @audio.stop() if @audio
    @audio = undefined
    @render()

  clearPlaylist: (event) ->
    app.playlist.clear()
    @stop()

  setCurrentTrack: (event) ->
    app.playlist.setCurrent event.currentTarget.dataset.id
    @stop()
    @play()

  addedToPlaylist: =>
    @play() unless @audio
    @render()

  initialize: ->
    app.playlist.on "add", @addedToPlaylist

  render: =>
    if app.playlist.length > 0
      @$el.html _.template @template, playlist: app.playlist, audio: @audio
    else
      @$el.html ''

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

    <ul class="nav">
      <li class="dropdown">

        <a class="dropdown-toggle current_track" data-toggle="dropdown">
          <%= playlist.current().get('artist') %> <span>▸</span>
          <%= playlist.current().get('album') %> <span>▸</span>
          <%= playlist.current().get('title') %> <span>▸</span>
          <span class="timer">00:00</span>
        </a>

        <ul class="dropdown-menu playlist">
          <% playlist.each(function(track){ %>
            <li class="set_current_track" data-id="<%= track.id %>">
              <a>
              <%= track.get('artist') %> <span>▸</span>
              <%= track.get('album') %> <span>▸</span>
              <%= track.get('title') %>
              </a>
            </li>
          <% }) %>
          <li class="divider"></li>
          <li><a class="clear_playlist">Clear</a></li>
        </ul>

      </li>
    </ul>
  """