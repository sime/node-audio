class app.views.Tracks extends Backbone.View
  tagName:   'div'
  id: 'tracks'
  className: 'row-fluid'

  render: =>
    tracks = @collection.filterBy (track) =>
      new app.views.Track(model: track).render().el

    @$el.html _.template @template
    @$el.find('tbody').html tracks
    @

  template: """
    <table class="table table-striped">
      <tbody></tbody>
    </table>
  """