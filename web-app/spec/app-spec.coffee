describe 'App', ->

  it 'should return correct createLink', ->
    App.data = {baseUrl: '/test'}
    expect(App.createLink('execute')).toBe '/test/console/execute'
    expect(App.createLink('execute', {a: 'aaa', b: 'bbb'})).toBe '/test/console/execute?a=aaa&b=bbb'





