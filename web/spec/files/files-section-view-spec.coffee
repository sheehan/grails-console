describe 'App.Files.FilesSectionView', ->

  beforeEach ->
    @store = new App.Entities.LocalFileStore('test')
    App.addFileStore @store
    @store.destroyAll()

    App.settings = new App.Entities.Settings()

    @$el = $('<div></div>').appendTo('body')
    @view = new App.Files.FilesSectionView collection: new App.Entities.FileCollection()

  afterEach ->
    App.removeFileStore @store

    @view.close()
    @$el.remove()

  it 'should render', ->
    @$el.append @view.render().$el
    expect(@view.$el).toHaveClass 'files-section-view'

  it 'should update name', ->
    @$el.append @view.render().$el
    @view.setName 'test'
    expect(@view.$('input.file-name').val()).toBe 'test'




