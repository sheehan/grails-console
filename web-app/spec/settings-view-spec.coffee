describe 'App.Main.SettingsView', ->

  beforeEach ->
    @settings = new App.Entities.Settings
      'orientation': 'vertical'
      'results.wrapText': true
      'theme': 'lesser-dark'

    @view = new App.Main.SettingsView model: @settings

    @$el = $('<div></div>').appendTo('body')

    @$el.append @view.render().$el

  afterEach ->
    @view.close()
    @$el.remove()

  it 'should preselect the correct settings', ->
    expect(@view.$('.orientation-horizontal')).toBe ':not(.selected)'
    expect(@view.$('.orientation-vertical')).toBe '.selected'
    expect(@view.$('.results-wrap')).toBe '.selected'
    expect(@view.$('.theme[data-theme="default"]')).toBe ':not(.selected)'
    expect(@view.$('.theme[data-theme="lesser-dark"]')).toBe '.selected'

  it 'should handle click events', ->
    @view.$('.orientation-horizontal').click()
    expect(@settings.get('orientation')).toBe 'horizontal'
    expect(@view.$('.orientation-horizontal')).toBe '.selected'
    expect(@view.$('.orientation-vertical')).toBe ':not(.selected)'

    @view.$('.results-wrap').click()
    expect(@settings.get('results.wrapText')).toBe false
    expect(@view.$('.results-wrap')).toBe ':not(.selected)'

    @view.$('.theme[data-theme="default"]').click()
    expect(@settings.get('theme')).toBe 'default'
    expect(@view.$('.theme[data-theme="default"]')).toBe '.selected'
    expect(@view.$('.theme[data-theme="lesser-dark"]')).toBe ':not(.selected)'





