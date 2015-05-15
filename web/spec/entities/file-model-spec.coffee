describe 'App.Entities.File', ->

  beforeEach ->
    App.data = {}
    @model = new App.Entities.File()

  it 'should return isDirectory', ->
    @model.set type: 'file'
    expect(@model.isDirectory()).toBe false

    @model.set type: 'dir'
    expect(@model.isDirectory()).toBe true

  it 'should return isFile', ->
    @model.set type: 'file'
    expect(@model.isFile()).toBe true

    @model.set type: 'dir'
    expect(@model.isFile()).toBe false

  it 'checks newFileText', ->
    expect(@model.get 'text').toBe ''

    App.data = { newFileText: 'abc' }
    @model = new App.Entities.File()
    expect(@model.get 'text').toBe 'abc'
