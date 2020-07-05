import dimscord, asyncdispatch, plugins, os, strutils

# Quit if token isn't set
let token = getEnv("DISCORD_BOT_API_TOKEN")
if token == "":
  stderr.writeLine("DISCORD_BOT_API_TOKEN Environment variable not set")
  quit(1)

# Setup plugins first
const base = currentSourcePath.parentDir()
var manager = initPlugins(@[base / "plugins"], @[])

while manager.run != stopped:
  syncPlugins(manager)
  if manager.ready:
    echo "Plugins Loaded: " & plist(manager).join(" ")
    break

let cl = newDiscordClient(token)
cl.debug = true
cl.autoreconnect = true

# Now setup events
cl.events.on_ready = proc (s: Shard, r: Ready) =
    echo "Connected to Discord as " & $r.user

# Event handler for new messages the bot sees
cl.events.message_create = proc (s: Shard, m: Message) =
  if m.author.bot: return
  if m.content != "":
    let tokens = m.content.split(" ")
    var command = tokens[0]
    var parameters = tokens[1..len(tokens)-1]
    
    if command == "!help":
      # This command is special as it does not use a plugin, meta-command
      let pluginList = plist(manager).join(", ")
      discard cl.api.sendMessage(m.channel_id, "**Available commands**: " & pluginList)
    elif command.startsWith('!'):
      command.removePrefix('!')
      let cmd = newCmdData(parameters.join(" "))
      try:
        call(manager, command, cmd)
        discard cl.api.sendMessage(m.channel_id, cmd.returned.join(" "))
      except:
        discard

waitFor cl.startSession()
