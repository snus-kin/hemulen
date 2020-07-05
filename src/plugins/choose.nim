import plugins/api
import random, lists, strutils

proc choose(plugin: Plugin, cmd: CmdData) {.plugincallback.} =
  var tokens = initSinglyLinkedList[string]()
  
  for param in cmd.params:
    if param notin ["should", "could", "?", "i", "you", "or", "do"]:
      var stripped = param
      stripped.removeSuffix(',')
      tokens.append(stripped)

  let pick = sample(cmd.params)
  cmd.returned.add pick

pluginLoad:
  discard

pluginReady:
  discard
