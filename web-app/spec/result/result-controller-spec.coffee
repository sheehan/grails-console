describe 'App.Result.History', ->

  beforeEach ->
    @history = new App.Result.History

  it 'should return correct prev or next', ->
    @history.add 'a'
    expect(@history.getPrev()).toBe 'a'
    expect(@history.getPrev()).toBe 'a'

    @history.add 'b'
    expect(@history.getPrev()).toBe 'b'
    expect(@history.getPrev()).toBe 'a'
    expect(@history.getPrev()).toBe 'a'
    expect(@history.getNext()).toBe 'b'
    expect(@history.getNext()).toBe ''
    expect(@history.getNext()).toBe ''





