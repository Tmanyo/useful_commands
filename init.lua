-- Shows a message in chat when a player kills another player.
minetest.register_on_punchplayer(function(player, hitter, tool_capabilities, damage)
     local player_hit = player:get_player_name()
     local criminal = hitter:get_player_name()
     local murder_weapon = hitter:get_wielded_item():to_string()
     minetest.after(.1, function()
          local health = player:get_hp()
          if health == 0 then
               minetest.chat_send_all(criminal .. " killed " .. player_hit .. " with " .. murder_weapon .. ".")
          end
     end)
end)

-- Shows a connecting message when someone is connecting.
minetest.register_on_prejoinplayer(function(name, ip)
     minetest.chat_send_all(name .." is connecting!")
end)

-- Server Reboot.
minetest.register_chatcommand("reboot", {
     description = "Warn players and reboot server",
     func = function(name, param)
          if minetest.check_player_privs(name, {server=true}) == true then
               minetest.chat_send_all("[Server] Rebooting in 1 minute!")
               minetest.after(60, function()
                    minetest.request_shutdown()
               end)
               minetest.after(10, function()
                    minetest.chat_send_all("[Server] Rebooting in 50 seconds!")
               end)
               minetest.after(20, function()
                    minetest.chat_send_all("[Server] Rebooting in 40 seconds!")
               end)
               minetest.after(30, function()
                    minetest.chat_send_all("[Server] Rebooting in 30 seconds!")
               end)
               minetest.after(40, function()
                    minetest.chat_send_all("[Server] Rebooting in 20 seconds!")
               end)
               minetest.after(50, function()
                    minetest.chat_send_all("[Server] Rebooting in 10 seconds!")
               end)
          end
     end
})

minetest.register_privilege("nonmanipulatable", "Can't manipulate player with this priv.")

-- Manipulate other players.
minetest.register_chatcommand("manipulate", {
     params = "<name> <text>",
     description = "Say something as someone else if you have the server priv.",
     func = function(name, params)
          if minetest.check_player_privs(name, {server=true}) == true then
               local s = params
               local manipulated_name = s:match("%w+")
               local manipulated_text = s:match(" %w+ ..+") or s:match(" %w+")
               if minetest.check_player_privs(manipulated_name, {nonmanipulatable=true}) == true then
                    minetest.chat_send_all("<" .. name ..">" .. manipulated_text)
                    if minetest.get_modpath("irc") then
                         if irc.connected and irc.config.send_join_part then
                              irc:say("<" .. name .. ">" .. manipulated_text)
                         end
                    end
               else
                    if manipulated_text == nil then
                         minetest.chat_send_player(name, "Invalid Parameters.")
                         return false
                    else
                         if minetest.check_player_privs(name, {server=true}) == true then
                              minetest.chat_send_all("<" .. manipulated_name .. ">" .. manipulated_text)
                         end
                         if minetest.get_modpath("irc") then
                              if irc.connected and irc.config.send_join_part then
                                   irc:say("<" .. manipulated_name .. ">" .. manipulated_text)
                              end
                         end
                    end
               end
          end
     end
})

minetest.register_chatcommand("virus", {
     param = "<name>",
     description = "Popup on a player's screen.",
     func = function(name, param)
          minetest.show_formspec(param, "chat_enhancements:virus",
               "size[6,3]" ..
               "background[0,0;6,3;virus.png;true]" ..
               "image_button_exit[5.75,-.3;.5,.5;exit.png;exit;;;false;]" ..
               "image[0,.75;1,1;warning.png]" ..
               "label[0,-.3;Warning!!]" ..
               "image[1,.25;6,2.5;text.png]" ..
               "button_exit[4,2.25;2,1;leave;Close]")
     end
})

minetest.register_chatcommand("afk", {
     description = "Proclaim that you are away from keyboard.",
     func = function(name, param)
          local player = minetest.get_player_by_name(name)
          player:set_nametag_attributes({text = "[AFK]" .. name .. "[AFK]"})
          minetest.chat_send_player(player:get_player_name(), "[Server] You are now marked away!")
     end
})

minetest.register_chatcommand("back", {
     description = "Proclaim that you are back from being away.",
     func = function(name, param)
          local player = minetest.get_player_by_name(name)
          player:set_nametag_attributes({text = name})
          minetest.chat_send_player(player:get_player_name(), "[Server] You are no longer marked away!")
     end
})

minetest.register_chatcommand("name_change", {
     param = "<name>",
     description = "Change your name.",
     func = function(name, param)
          local player = minetest.get_player_by_name(name)
          player:set_nametag_attributes({text = param})
          minetest.chat_send_player(name, "[Server] You successfully changed your name!")
     end
})
