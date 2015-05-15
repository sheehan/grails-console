describe 'App.Result.ResultView', ->

  beforeEach ->
    @model = new App.Result.Result
    @view = new App.Result.ResultView
      model: @model

  afterEach ->

  it 'should convertTreeNode', ->
    @model.set
      result: 'test-name'
      resultTree:
        a: 'a'
        b: 'b'
      input: 'test'

    result = @view.serializeData()

    expect(result.resultTree).toEqual
      name: 'test-name'
      children: [
        {name: 'a', value: 'a'}
        {name: 'b', value: 'b'}
      ]

    @model.set
      result: 'test-name'
      resultTree: ['aaa', 'bbb', 'ccc']
      input: 'test'

    result = @view.serializeData()

    expect(result.resultTree).toEqual
      name: 'test-name'
      children: [
        {name: 'aaa'}
        {name: 'bbb'}
        {name: 'ccc'}
      ]