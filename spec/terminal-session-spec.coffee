os = require 'os'

TerminalSession = require '../lib/terminal-session'

describe "TerminalSession", ->
  session = null

  beforeEach ->
    path = if process.platform is 'win32' then 'c:\\' else '~'
    runs -> session = new TerminalSession(path)
    waitsFor "initial terminal data event", (done) -> session.once 'data', done

  afterEach ->
    session?.destroy()

  describe "exiting shell", ->
    it "emits the exit event", ->
      session.input("exit#{os.EOL}")
      waitsFor "data event response to input", (done) ->
        session.on "exit", ->
          done()

  describe "input", ->
    it "sends inputs to terminal process", ->
      session.input("echo a; sleep 1; exit#{os.EOL}")
      waitsFor "data event response to input",(done) ->
        buffer = ''
        expected = "echo a; sleep 1; exit#{os.EOL}a#{os.EOL}"
        session.on 'data', (data) ->
          buffer += expected
        session.on 'exit', ->
          expect(buffer).toContain expected
          done()
