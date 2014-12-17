describe 'App.Util', ->

  it 'can snakeToCamel()', ->
    data =
      'xxx':          'xxx'
      'xxx_yyy':      'xxxYyy'
      'xxx_yyy_zzz':  'xxxYyyZzz'
      'camelCase':    'camelCase'

    for input, expected of data
      expect(App.Util.snakeToCamel(input)).toBe expected