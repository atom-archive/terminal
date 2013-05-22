TerminalBuffer = require 'terminal/lib/terminal-buffer'
RootView = require 'root-view'

fdescribe "Terminal Buffer", ->
  beforeEach ->
    window.rootView = new RootView
    atom.activatePackage 'terminal'
