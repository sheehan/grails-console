describe 'App.Result.ResultView', ->

  beforeEach ->
    @model = new App.Result.Result
    @view = new App.Result.ResultView
      model: @model

  afterEach ->

  it 'should convertTreeNode', ->
    @model.set
      resultTree:
        a: 'a'
        b: 'b'
      input: 'test'

    result = @view.serializeData()

    expect(result.resultTree).toEqual [
      {name: 'a', value: 'a'}
      {name: 'b', value: 'b'}
    ]

    @model.set
      resultTree: ['aaa', 'bbb', 'ccc']
      input: 'test'

    result = @view.serializeData()

    expect(result.resultTree).toEqual [
      {name: 'aaa'}
      {name: 'bbb'}
      {name: 'ccc'}
    ]
