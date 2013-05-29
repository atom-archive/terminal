TerminalSession = require 'terminal/lib/terminal-session'
TerminalBuffer = require 'terminal/lib/terminal-buffer'

fdescribe "TerminalSession", ->
  session = null

  beforeEach ->
    session = new TerminalSession('~')

  afterEach ->
    session?.destroy()

  describe "data events", ->
    it "forwards data events from the underlying terminal process", ->
      waitsFor "data event", (done) -> session.one 'data', done

  describe "buffer", ->
    it "creates a terminal buffer", ->
      expect(session.buffer instanceof TerminalBuffer).toBeTruthy()


  describe "input", ->
    it "sends inputs to terminal process", ->
      session.input("logout\n")
      waitsFor "exit", -> session.exitCode == 0
