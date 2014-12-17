describe 'App', ->

  it 'should return correct createLink', ->
    App.data = {baseUrl: '/test/console'}
    expect(App.createLink('execute')).toBe '/test/console/execute'
    expect(App.createLink('execute', {a: 'aaa', b: 'bbb'})).toBe '/test/console/execute?a=aaa&b=bbb'

  it 'should convert any snake params to camel (#10)', ->
    App.start
      base_url: 'xxx'
      somethingElse: 'yyy'

    expect(App.data).toEqual
      base_url: 'xxx'
      baseUrl: 'xxx'
      somethingElse: 'yyy'





