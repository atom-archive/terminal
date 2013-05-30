TerminalView = require 'terminal/lib/terminal-view'
RootView = require 'root-view'
EventEmitter = require 'event-emitter'
_ = require 'underscore'

fdescribe "Terminal view", ->
  [view, session] = []

  makeChars = (chars...) ->
    c = []
    for char in chars
      c.push({char: char})
    c

  beforeEach ->
    window.rootView = new RootView
    atom.activatePackage 'terminal'
    session = {}
    _.extend session, EventEmitter
    view = new TerminalView(session)

  describe "update event", ->
    it "adds a new line", ->
      session.trigger 'update', {lineNumber:1, chars:makeChars("a")}
      waitsFor "view update", (done) ->
        view.one 'view-updated', ->
          expect(view.find(".line").size()).toBe(1)
          expect(view.find(".line span").text()).toBe("a")
          done()

    it "updates the content of an existing line", ->
      session.trigger 'update', {lineNumber:1, chars:makeChars("a")}
      session.trigger 'update', {lineNumber:1, chars:makeChars("b")}
      waitsFor "view update", (done) ->
        view.one 'view-updated', ->
          expect(view.find(".line").size()).toBe(1)
          expect(view.find(".line span").text()).toBe("b")
          done()
