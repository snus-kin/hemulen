import plugins/api
import strformat, httpclient, htmlparser, xmltree

proc horoscope(plugin: Plugin, cmd: CmdData) {.plugincallback.} =
  if len(cmd.params) != 1:
    cmd.returned.add "Usage: !horroscope <sign>"
  else:
    let sign = cmd.params[0]
    let client = newHttpClient()
    let resp = client.getContent(fmt"https://my.horoscope.com/astrology/free-daily-horoscope-{sign}.html")
    client.close()
    
    var text = resp.parseHtml.findAll("p")[0].innerText

    cmd.returned.add text

pluginLoad:
  discard

pluginReady:
  discard
