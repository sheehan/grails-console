describe 'App.Util.Path', ->

  it 'should return correct hasParent', ->
    data =
      '/':        false
      '/aaa':     true
      '/aaa/':    true
      '/aaa/bbb': true
      'C:/':      false
      'C:/aaa':   true

    for path, expected of data
      expect(App.Util.Path.hasParent(path)).toBe expected

  it 'should return correct getParent', ->
    data =
      '/':            null
      '/aaa':         '/'
      '/aaa/':        '/'
      '/aaa/bbb':     '/aaa/'
      '/aaa/bbb/ccc': '/aaa/bbb/'
      'C:/':          null
      'C:/aaa':       'C:/'

    for path, expected of data
      expect(App.Util.Path.getParent(path)).toBe expected

  it 'should return correct getCurrentDir', ->
    data =
      '/':          ''
      '/aaa':       'aaa'
      '/aaa/':      'aaa'
      '/aaa/bbb':   'bbb'
      'C:/  ':        'C:'
      'C:/aaa':     'aaa'
      'C:/aaa/bbb': 'bbb'

    for path, expected of data
      expect(App.Util.Path.getCurrentDir(path)).toBe expected