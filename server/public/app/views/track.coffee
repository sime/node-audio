class app.views.Track extends Backbone.View
  tagName: 'tr'

  events:
    "click .artist" : "addArtist"
    "click .album"  : "addAlbum"
    "click .title"  : "addTitle"

  addTitle: (event) =>
    app.playlist.add @model

  addAlbum: (event) =>
    tracks = app.tracks.getByAlbum @model.get('album')
    _.each tracks, (track) ->
      try app.playlist.add(track) catch e



  addArtist: (event) =>
    tracks = app.tracks.getByArtist @model.get('artist')
    _.each tracks, (track) ->
      try app.playlist.add(track) catch e

  render: =>
    @$el.html _.template @template, @model
    @

  template: """
    <td class="artist"><%= get('artist') %></td>
    <td class="album"><%= get('album') %></td>
    <td class="title"><%= get('title') %></td>
  """