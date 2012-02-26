class app.models.Application extends Backbone.Model


class app.models.Track extends Backbone.Model


class app.collections.Playlist extends Backbone.Collection
  model: app.models.Track

  prev: ->
    index = @indexOf(@current) - 1
    if index >= 0
      @current_pos = @at index
    else
      @current_pos = @at 0

  current: ->
    @current_pos ||= @first()

  next: ->
    index = @indexOf(@current()) + 1
    if index < @length
      @current_pos = @at index
    else
      @current_pos = @at 0



class app.collections.Tracks extends Backbone.Collection
  model: app.models.Track
  url: '/metadata.json'

  filterBy: (func)->
    toFilterBy = new RegExp (app.models.application.get('toFilterBy') || ''), 'i'
    (@.filter (track) =>
      toSearch = track.get('artist') + track.get('album') + track.get('title')
      toSearch.search(toFilterBy) != -1
    ).slice(0, 500).map func

  artists: ->
    _.uniq _.map(@pluck('artist'), (artist) -> artist.toLowerCase())

  getByArtist: (artist) ->
    @filter (track) -> track.get('artist').toLowerCase() == artist.toLowerCase()

  getByAlbum: (album) ->
    @filter (track) -> track.get('album').toLowerCase() == album.toLowerCase()


