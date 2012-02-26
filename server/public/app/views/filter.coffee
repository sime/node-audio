class app.views.Filter extends Backbone.View
  tagName:   'div'
  className: 'navbar-search pull-left'

  events:
    "change input":  "change"

  initialize: ->
    app.models.application.bind "change", @render

  change: (event) ->
    if event.target.value == ""
      app.router.navigate "", trigger: true, replace: true
    else
      app.router.navigate "#/filter/#{event.target.value}", trigger: true, replace: true

  render: =>
    @$el.html "<input type=\"text\" class=\"search-query span2\" value=\"#{app.models.application.get("toFilterBy") || ''}\">"
    @