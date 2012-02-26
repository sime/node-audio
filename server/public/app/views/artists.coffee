class app.views.Artists extends Backbone.View
  tagName: 'ul'
  id: 'artists'
  className: 'row-fluid'

  render: =>
    @$el.html _.template @template, artists: @collection.artists()
    @

  template: """
    <% _.each(artists, function(artist){ %>
      <li><a href="#/filter/<%= artist %>"><%= artist %></a></li>
    <% }) %>
  """