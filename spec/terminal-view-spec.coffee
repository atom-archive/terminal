TerminalView = require 'terminal/lib/terminal-view'
RootView = require 'root-view'

fdescribe "Terminal view", ->
  [view, session] = []
  beforeEach ->
    window.rootView = new RootView
    atom.activatePackage 'terminal'
    session = {}
    view = new TerminalView(session)

  describe "update event", ->
    it "adds a new line", ->
      view.trigger 'update', {lineNumber:1, rows:["a"]}
      expect(view.find(".line").size()).toBe(1)
      expect(view.find(".line span").text()).toBe("a")

    it "updates the content of an existing line", ->
      view.trigger 'update', {lineNumber:1, rows:["a"]}
      view.trigger 'update', {lineNumber:1, rows:["b"]}
      expect(view.find(".line").size()).toBe(1)
      expect(view.find(".line span").text()).toBe("b")
