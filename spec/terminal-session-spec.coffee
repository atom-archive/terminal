TerminalSession = require 'terminal/lib/terminal-session'

describe "TerminalSession", ->
  session = null

  afterEach ->
    session?.destroy()

  describe "data events", ->
    it "forwards data events from the underlying terminal process", ->
      session = new TerminalSession('~')
      waitsFor "data event", (done) -> session.one 'data', done
