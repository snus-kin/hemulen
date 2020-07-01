import plugins/api
import strutils, httpclient, json

proc lookUp(plugin: Plugin, cmd: CmdData) {.plugincallback.} =
  let queryText = cmd.params.join(" ")
  let client = newHttpClient()
  let result = client.get("https://api.duckduckgo.com/?format=json&q=" & queryText)
  let jsonResult = parseJson(result.body)["Answer"].getStr
  echo jsonResult

  cmd.returned.add jsonResult

pluginLoad:
  discard

pluginReady:
  discard
