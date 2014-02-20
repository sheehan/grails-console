describe 'App.Main.Help', ->

  beforeEach ->
    @$el = $('<div></div>').appendTo('body')
    @view = new App.Main.HelpView
    @$el.append @view.render().$el

  afterEach ->
    @view.close()
    @$el.remove()

  it 'should have right className', ->
    expect(@view.$el).toHaveClass 'modal-dialog'

  it 'should serializeData', ->
    App.data.implicitVars = {test: 'test'}
    expect(@view.serializeData().implicitVars.test).toBe 'test'