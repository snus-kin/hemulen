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
      href.removePrefix("//duckduckgo.com/l/?kh=-1&uddg=")
      # Bizzare error sending links with a %2F char
      href.removeSuffix('/')
      break

  if href != "":
    cmd.returned.add href
  else:
    cmd.returned.add "No results found"

  client.close()


pluginLoad:
  discard

pluginReady:
  discard
