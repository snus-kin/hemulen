import plugins/api
import strutils

proc echo(plugin: Plugin, cmd: CmdData) {.plugincallback.} =
  cmd.returned.add cmd.params.join(" ")

pluginLoad:
  discard

pluginReady:
  discard
