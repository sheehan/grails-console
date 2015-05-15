describe 'App.Util', ->

  it 'can snakeToCamel()', ->
    data =
      'xxx':          'xxx'
      'xxx_yyy':      'xxxYyy'
      'xxx_yyy_zzz':  'xxxYyyZzz'
      'camelCase':    'camelCase'

    for input, expected of data
      expect(App.Util.snakeToCamel(input)).toBe expected

  it 'can padRight()', ->
    expect(App.Util.padRight 'x', 10).toBe          'x         '
    expect(App.Util.padRight 'xxxxxxxxxx', 10).toBe 'xxxxxxxxxx'
    expect(App.Util.padRight 'x', 10, 'y').toBe     'xyyyyyyyyy'