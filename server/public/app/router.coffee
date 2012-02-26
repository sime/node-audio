class app.Router extends Backbone.Router

  routes:
    "/play/:id":              "play"
    "/filter/:filter":        "filter"
    "":                       "home"

  initialize: ->
    app.models.application = new app.models.Application()
    app.tracks = new app.collections.Tracks()
    app.playlist = new app.collections.Playlist()

    $("#filter_wrapper").append new app.views.Filter().render().el
    $("#playlist_wrapper").append new app.views.Playlist().el

  play: (id) ->
    app.tracks.fetch success: =>
      app.playlist.add app.tracks.get(id)

  filter: (toFilterBy) ->
    app.models.application.set 'toFilterBy': toFilterBy
    app.tracks.fetch success: =>
      tracksView = new app.views.Tracks(collection: app.tracks).render()
      $("#body").html tracksView.el

  home: ->
    app.models.application.set 'toFilterBy': undefined
    app.tracks.fetch success: =>
      artistsView = new app.views.Artists(collection: app.tracks).render()
      $("#body").html artistsView.el


app.router = new app.Router()
Backbone.history.start()