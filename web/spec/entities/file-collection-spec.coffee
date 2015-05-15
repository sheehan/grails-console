describe 'App.Entities.FileCollection', ->

  beforeEach ->
    @collection = new App.Entities.FileCollection()

  it 'should sort correctly', ->
    @collection.add type: 'file', name: 'aaa'
    @collection.add type: 'file', name: 'xxx'
    @collection.add type: 'dir', name: 'bbb'
    @collection.add type: 'dir', name: 'zzz'

    expect(@collection.at(0).get('name')).toBe 'bbb'
    expect(@collection.at(1).get('name')).toBe 'zzz'
    expect(@collection.at(2).get('name')).toBe 'aaa'
    expect(@collection.at(3).get('name')).toBe 'xxx'

  it 'should add store to models', ->
    @collection.store = 'test'
    @collection.add type: 'file', name: 'aaa'

    expect(@collection.at(0).store).toBe 'test'
