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
    expect(@view.$('.orientation-horizontal')).not.toHaveClass 'selected'
    expect(@view.$('.orientation-vertical')).toHaveClass 'selected'
    expect(@view.$('.results-wrap')).toHaveClass 'selected'
    expect(@view.$('.theme[data-theme="default"]')).not.toHaveClass 'selected'
    expect(@view.$('.theme[data-theme="lesser-dark"]')).toHaveClass 'selected'

  it 'should handle click events', ->
    @view.$('.orientation-horizontal').click()
    expect(@settings.get('orientation')).toBe 'horizontal'
    expect(@view.$('.orientation-horizontal')).toHaveClass 'selected'
    expect(@view.$('.orientation-vertical')).not.toHaveClass 'selected'

    @view.$('.results-wrap').click()
    expect(@settings.get('results.wrapText')).toBe false
    expect(@view.$('.results-wrap')).not.toHaveClass 'selected'

    @view.$('.theme[data-theme="default"]').click()
    expect(@settings.get('theme')).toBe 'default'
    expect(@view.$('.theme[data-theme="default"]')).toHaveClass 'selected'
    expect(@view.$('.theme[data-theme="lesser-dark"]')).not.toHaveClass 'selected'





