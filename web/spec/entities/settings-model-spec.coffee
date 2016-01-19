describe 'App.Entities.Settings', ->

  beforeEach ->
    @settings = new App.Entities.Settings

  it 'should toggle booleans', ->
    expect(@settings.get('results.wrapText')).toBe(true)

    @settings.toggle('results.wrapText')
    expect(@settings.get('results.wrapText')).toBe(false)

    @settings.toggle('results.wrapText')
    expect(@settings.get('results.wrapText')).toBe(true)

  it 'should load from localStorage', ->
    expect(@settings.get('orientation')).toBe('vertical')

    spyOn(localStorage, 'getItem').and.callFake ->
      JSON.stringify
        orientation:'horizontal'

    @settings.load()
    expect(localStorage.getItem).toHaveBeenCalled()
    expect(@settings.get('orientation')).toBe('horizontal')

  it 'should save to localStorage', ->
    @settings.set
      orientation: 'horizontal'

    spyOn(localStorage, 'setItem').and.callFake ->

    @settings.save()
    expect(localStorage.setItem).toHaveBeenCalled()

  it 'should be able to save and load multiple times', ->
    @settings.set
      'orientation': 'horizontal'
      'layout.east.size': '20%'

    @settings.save()

    @settings = new App.Entities.Settings
    @settings.load()
    expect(@settings.get('orientation')).toBe 'horizontal'
    expect(@settings.get('layout.east.size')).toBe '20%'

    @settings.set
      'orientation': 'vertical'
      'layout.east.size': '30%'

    @settings.save()

    @settings = new App.Entities.Settings
    @settings.load()
    expect(@settings.get('orientation')).toBe 'vertical'
    expect(@settings.get('layout.east.size')).toBe '30%'