describe 'App.Editor.EditorView', ->

  beforeEach ->
    App.settings = new App.Entities.Settings()

    @view = new App.Editor.EditorView

    @$el = $('<div></div>').appendTo('body')
    @$el.append @view.render().$el

  afterEach ->
    @view.close()
    @$el.remove()

  it 'should setValue and getValue', ->
    @view.setValue 'test value'
    expect(@view.getValue()).toBe 'test value'

  it 'should setTheme', ->
    App.settings.set 'theme', 'test-theme'
    expect(@view.editor.getOption 'theme').toBe 'test-theme'

  it 'should execute new on click', ->
    spyOn App, 'execute'
    $('button.new').click()
    expect(App.execute).toHaveBeenCalledWith 'new'

  it 'should execute save on click', ->
    spyOn App, 'execute'
    $('button.save').click()
    expect(App.execute).toHaveBeenCalledWith 'save'

  it 'should execute saveAs on click', ->
    spyOn App, 'execute'
    $('a.save-as').click()
    expect(App.execute).toHaveBeenCalledWith 'saveAs'

  it 'should execute execute on click', ->
    spyOn App, 'execute'
    $('button.execute').click()
    expect(App.execute).toHaveBeenCalledWith 'execute'