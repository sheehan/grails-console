describe 'App.Entities.LocalFileStore', ->

  beforeEach ->
    @store = new App.Entities.LocalFileStore('test')
    App.addFileStore @store
    @store.destroyAll()

  afterEach ->
    App.removeFileStore @store

  it 'should start with empty list', ->
    expect(@store.list().length).toBe 0


  it 'should persist to localStorage', ->
    file = new App.Entities.File(name: 'test-name', text: 'test-text')
    @store.create file

    expect(@store.list().length).toBe 1

    @store = new App.Entities.LocalFileStore('test')
    expect(@store.list().length).toBe 1


  it 'should work with sync', ->
    file = new App.Entities.File(name: 'test-name', text: 'test-text')
    file.store = 'local'

    expect(file.id).not.toBeDefined()
    spyOn(@store, 'create').andCallThrough()
    file.save()

    expect(@store.list().length).toBe 1
    expect(@store.create).toHaveBeenCalled()
    expect(file.id).toBeDefined()

    file.set 'name', 'different'
    expect(file.get('name')).toBe('different')

    spyOn(@store, 'find').andCallThrough()
    file.fetch()

    expect(@store.find).toHaveBeenCalled()
    expect(file.get('name')).toBe('test-name')

    spyOn(@store, 'update').andCallThrough()
    file.save()

    expect(@store.list().length).toBe 1
    expect(@store.update).toHaveBeenCalled()

    spyOn(@store, 'destroy').andCallThrough()
    file.destroy()

    expect(@store.list().length).toBe 0
    expect(@store.destroy).toHaveBeenCalled()