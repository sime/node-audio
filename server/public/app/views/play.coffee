class app.views.Play extends Backbone.View
  tagName: 'div'
  id: 'player'

  next: =>
    if @audio.currentTime > 9000000000000 #9223372013568
      @model = @model.collection.getByCid "c#{parseInt(@model.cid.replace('c', '')) + 1}"
      console.log "next track"
      console.log @model
      @render()

  render: =>
    @$el.html _.template @template, @model
    #@$el.find('audio').bind 'ended', => @next()
    @audio = @$el.find('audio').get(0)
    window.setInterval @next, 30
    @

  template: """
    <audio controls autoplay autobuffer>
      <source src="<%= get('url') %>" type="audio/mp3" />
    </audio>
    <span class="title">
      <%= get('artist') %> <span>/</span> <%= get('album') %> <span>/</span> <%= get('title') %>
    </span>
  """