import dimscord, asyncdispatch, plugins, os, strutils
# Setup plugins first
const base = currentSourcePath.parentDir()
var manager = initPlugins(@[base / "plugins"], @[])

while manager.run != stopped:
  syncPlugins(manager)
  if manager.ready:
    echo "Plugins Loaded: " & plist(manager).join(" ")
    break

let cl = newDiscordClient("")
cl.debug = true

# Now setup events
cl.events.on_ready = proc (s: Shard, r: Ready) =
    echo "Connected to Discord as " & $r.user

# Event handler for new messages the bot sees
cl.events.message_create = proc (s: Shard, m: Message) =
  if m.author.bot: return
  if m.content[0] == '!':
    let tokens = m.content.split(" ")
    let command = tokens[0]
    let parameters = tokens[1..len(tokens)-1]

    if command == "!echo":
      let cmd = newCmdData(parameters.join(" "))
      call(manager, "echo", cmd)
      discard waitFor cl.api.sendMessage(m.channel_id, cmd.returned[0])

waitFor cl.startSession()
