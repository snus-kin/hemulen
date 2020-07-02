import plugins/api
import strutils, httpclient, xmlparser, xmltree, uri

proc ddg(plugin: Plugin, cmd: CmdData) {.plugincallback.} =
  let queryText = cmd.params.join(" ")
  let client = newHttpClient()
  let result = client.getContent("https://duckduckgo.com/html/?q=" & queryText)
  
  let lines = result.splitLines()
  var href: string = ""
  for line in lines:
    if "result__a" in line:
      var link = parseXml(line)
      href = link.attr("href").decodeUrl
      # extra parsing required
      break

  cmd.returned.add href

pluginLoad:
  discard

pluginReady:
  discard
