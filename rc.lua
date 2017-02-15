local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
local wibox = require("wibox")
local beautiful = require("beautiful")
local lain = require("lain")
local vicious = require("vicious")
local naughty = require("naughty")
local menubar = require("menubar")
local c_util = require("c_util")
local hotkeys_popup = require("awful.hotkeys_popup").widget

-- for fcitx-chttrans
table.insert(naughty.config.icon_dirs, '/usr/share/icons/hicolor/48x48/apps/')
table.insert(naughty.config.icon_dirs, '/usr/share/icons/hicolor/48x48/status/')

os.setlocale("zh_CN.UTF-8")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init(os.getenv("HOME") .. "/.config/awesome/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "xfce4-terminal"
editor = "code" or "nvim" or os.getenv("EDITOR") or "editor"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    -- awful.layout.suit.tile.top,
    lain.layout.termfair,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.spiral,
    -- awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier,
    -- awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}
lain.layout.termfair.nmaster = 2
lain.layout.termfair.ncol = 1
-- }}}

-- {{{ Helper functions
local function client_menu_toggle_fn()
    local instance = nil

    return function ()
        if instance and instance.wibox.visible then
            instance:hide()
            instance = nil
        else
            instance = awful.menu.clients({ theme = { width = 250 } })
        end
    end
end
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
m_awesome = {
  { "编辑配置 (&E)", editor .. " " .. awesome.conffile },
  { "重新加载 (&R)", awesome.restart },
  { "Session注销 (&U)", "xfce4-session-logout"},
  { "注销 (&L)", awesome.quit },
}

m_main = awful.menu({ items = {
    { "&Awesome", m_awesome, beautiful.awesome_icon },
    { "Thunar (&F)", "thunar ", "/usr/share//icons/hicolor/16x16/apps/Thunar.png" },
    { "&Google Chrome", "google-chrome-unstable", "/usr/share/icons/hicolor/16x16/apps/google-chrome-unstable.png"},
    { "&Shadowsocks-Qt5", "ss-qt5" },
--    { "A&ndroid Studio", "android-studio" },
    { "Win&7", "/usr/lib/virtualbox/VirtualBox --comment \"Win7\" --startvm \"2843ab82-5bb9-4795-8712-1447b0a3046d\"" ,"/usr/share/icons/hicolor/16x16/mimetypes/virtualbox.png"},
    { "终端 (&T)", "xfce4-terminal"},
--    { "应用程序 (&P)", xdgmenu(terminal) },
    { "锁屏 (&L)", "light-locker-command -l", "/usr/share/icons/Numix/16/actions/lock.svg"},
    { "注销 (&O)", awesome.quit },
    { "重启 (&R)", "zenity --question --title '重启' --text '你确定重启吗？' --default-cancel && systemctl reboot", '/usr/share/icons/Numix/16/actions/reload.svg' },
    { "关机 (&H)", "zenity --question --title '关机' --text '你确定关机吗？' --default-cancel && systemctl poweroff", '/usr/share/icons/Numix/16/actions/gtk-quit.svg' },
}})

w_launcher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = m_main })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Widgets
markup = lain.util.markup

-- Text clock with calendar
local ico_clock = wibox.widget.imagebox(theme.widget_clock)
local w_textclock = wibox.widget.textclock(markup("#7788af", "%A %m月%d日") .. markup("#535f7a", ">") .. markup("#de5e1e", " %H:%M "))
local w_cal = lain.widget.calendar({
    attach_to = { w_textclock },
    notification_preset = {
        font = "Terminus(TTF) 9",
        fg   = theme.fg_normal,
        bg   = theme.bg_normal
    }
})

-- Volume
local ico_volume = wibox.widget.imagebox(theme.widget_vol)
local w_volume = lain.widget.alsa({
    settings = function()
        if volume_now.status == "off" then
            volume_now.level = volume_now.level .. "M"
        end

        widget:set_markup(markup.fontfg(theme.font, "#7493d2", volume_now.level .. "% "))
    end
})
w_volume.widget:buttons(awful.util.table.join(
    awful.button({ }, 4, function ()
            os.execute(string.format("amixer set %s 3%%+", w_volume.channel))
            w_volume.update()
        end),
    awful.button({ }, 5, function ()
            os.execute(string.format("amixer set %s 3%%-", w_volume.channel))
            w_volume.update()
        end),
    awful.button({ }, 3, function () awful.util.spawn("pavucontrol") end),
    awful.button({ }, 1, function ()
            os.execute(string.format("amixer set %s toggle", w_volume.channel))
            w_volume.update()
        end)
))

-- Battery
local ico_bat = wibox.widget.imagebox(theme.widget_batt)
local w_bat = lain.widget.bat({
    settings = function()
        if bat_now.perc ~= "N/A" then
            bat_now.perc = bat_now.perc .. "%"
        end
        if bat_now.ac_status == 1 then
            bat_now.perc = bat_now.perc .. " plug"
        end

        widget:set_markup(markup.fontfg(theme.font, theme.fg_normal, bat_now.perc .. " "))
    end
})

-- Uptime
local ico_uptime = wibox.widget.imagebox(theme.widget_uptime)
local w_uptime = wibox.widget.textbox()
vicious.register(w_uptime, vicious.widgets.uptime,
    function (widget, args)
        return string.format("%2dd %02d:%02d ", args[1], args[2], args[3])
    end, 61)

-- Mem
local ico_mem = wibox.widget.imagebox(theme.widget_mem)
local w_mem = lain.widget.mem({
    settings = function()
        widget:set_markup(markup.fontfg(theme.font, "#e0da37", mem_now.used .. "M S:" .. mem_now.swapused .. "M"))
    end
})

-- CPU
local ico_cpu = wibox.widget.imagebox(theme.widget_cpu)
local w_cpu = lain.widget.cpu({
    settings = function()
        widget:set_markup(markup.fontfg(theme.font, "#e33a6e", cpu_now.usage .. "% "))
    end
})

-- Net
local ico_netdown = wibox.widget.imagebox(theme.widget_netdown)
local w_netdowninfo = wibox.widget.textbox()
local ico_netup = wibox.widget.imagebox(theme.widget_netup)
local w_netupinfo = lain.widget.net({
    settings = function()
--[[        if iface ~= "network off" and
           string.match(theme.weather.widget.text, "N/A")
        then
            theme.weather.update()
        end
--]]

        widget:set_markup(markup.fontfg(theme.font, "#e54c62", net_now.sent .. " "))
        w_netdowninfo:set_markup(markup.fontfg(theme.font, "#87af5f", net_now.received .. " "))
    end
})
-- }}}

-- {{{ Deal with screens
local taglist_buttons = awful.util.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ modkey }, 1, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, function(t)
                                              if client.focus then
                                                  client.focus:toggle_tag(t)
                                              end
                                          end),
                    awful.button({ }, 4, function(t) lain.util.tag_view_nonempty(-1) end),
                    awful.button({ }, 5, function(t) lain.util.tag_view_nonempty(1) end)
                )

local tasklist_buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() and c.first_tag then
                                                      c.first_tag:view_only()
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, client_menu_toggle_fn()),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                          end))

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    awful.tag({ "1Term", "2Web", "3E", "4E", "5V", "6QQ", "7", "8", "9", '0' }, s, {
    lain.layout.termfair,
    awful.layout.suit.max,
    awful.layout.suit.tile,
    awful.layout.suit.tile,
    awful.layout.suit.tile,
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile,
    awful.layout.suit.tile,
    awful.layout.suit.floating,
    })

    -- Create a promptbox for each screen
    s.ws_promptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.ws_layoutbox = awful.widget.layoutbox(s)
    s.ws_layoutbox:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.ws_taglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons)

    -- Create a tasklist widget
    s.ws_tasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist_buttons)

    -- Create the wibox
    s.upbox = awful.wibar({ position = "top", screen = s })

    -- Add widgets to the wibox
    s.upbox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            w_launcher,
            s.ws_taglist,
            s.ws_promptbox,
        },
        nil, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            ico_netdown,
            w_netdowninfo,
            ico_netup,
            w_netupinfo.widget,
            ico_cpu,
            w_cpu,
            ico_mem,
            w_mem,
            ico_uptime,
            w_uptime,
            ico_volume,
            w_volume,
            ico_bat,
            w_bat,
            wibox.widget.systray(),
            ico_clock,
            w_textclock,
        },
    }
    
    s.bottombox = awful.wibar({ position = "bottom", screen = s, border_width = 0, height = 20, bg = theme.bg_normal, fg = theme.fg_normal })

    -- Add widgets to the bottom wibox
    s.bottombox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
        },
        s.ws_tasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            s.ws_layoutbox,
        },
    }

end)
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () m_main:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
    awful.key({ "Mod1",           }, "Tab",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ "Mod1",           }, "Tab",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
    awful.key({ modkey,           }, "w", function () m_main:show() end,
              {description = "show main menu", group = "awesome"}),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),

    -- Standard program
    awful.key({ modkey,           }, "Return", function ()
                -- Go and find a terminal for me
                c_util.run_or_raise("xfce4-terminal --role=TempTerm --geometry=100x35+343+180", { role = "TempTerm" })
                end,
              {description = "open a new temp terminal or find one existing", group = "launcher"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),

    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                      client.focus = c
                      c:raise()
                  end
              end,
              {description = "restore minimized", group = "client"}),

    -- Prompt
    awful.key({ modkey, "Mod1" },    "r"   ,     function () awful.screen.focused().ws_promptbox:run() end,
              {description = "run prompt", group = "launcher"}),
    awful.key({ "Mod1" },            "F2"  ,     function () awful.screen.focused().ws_promptbox:run() end,
              {description = "run prompt", group = "launcher"}),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().ws_promptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                  }
              end,
              {description = "lua execute prompt", group = "awesome"}),
    -- Menubar
    awful.key({ modkey }, "r", function() menubar.show() end,
              {description = "show the menubar", group = "launcher"}),
    
    -- Non-empty tag browsing
    awful.key({ modkey,           }, "p", function() lain.util.tag_view_nonempty(-1) end,
              {description = "view previous non-empty", group = "tag"} ),
    awful.key({ modkey,           }, "n", function() lain.util.tag_view_nonempty(1) end,
              {description = "view next non-empty", group = "tag"}  ),

    -- screenshot
    awful.key({ "Control", "Mod1" }, "q", function() awful.util.spawn("xfce4-screenshooter -r") end,
              {description = "screenshot", group = "program"}),
    -- program shortcuts
    awful.key({ "Control", "Mod1", "Shift" }, "x", function () awful.util.spawn("xkill") end,
              {description = "xkill", group = "program"}),
    awful.key({ "Control", "Mod1"          }, "t", function () awful.util.spawn(terminal) end,
              {description = "open a terminal", group = "program"}),
    awful.key({ modkey,    "Shift"         }, "Return",
                function ()
                    awful.util.spawn("xfce4-terminal --role=TempTerm --geometry=100x35+343+180")
                end,
              {description = "open a temp terminal", group = "program"}),
    -- move temp client to tag10
    awful.key({ modkey,           }, "q",
        function ()
            local c = client.focus
            if not c then return end
            if c.role == 'FullScreenHtop' or c.role == 'TempTerm' then
                tag = client.focus.screen.tags[10]
                client.focus:move_to_tag(tag)
            end
        end),
    -- Volume
    awful.key({ }, 'XF86AudioRaiseVolume', function ()
            os.execute(string.format("amixer set %s 3%%+", w_volume.channel))
            w_volume.update()
        end),
    awful.key({ }, 'XF86AudioLowerVolume', function ()
            os.execute(string.format("amixer set %s 3%%-", w_volume.channel))
            w_volume.update()
        end),
    awful.key({ }, 'XF86AudioMute', function ()
            os.execute(string.format("amixer set %s toggle", w_volume.channel))
            w_volume.update()
        end)

)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ "Mod1"            }, "F4",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey, "Shift"   }, "m",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "maximize", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag and view that tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                              tag:view_only()
                          end
                      end
                  end,
                  {description = "move focused client to tag #".. i .." and view tag #"..i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Mod1" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },

    { rule_any = { class = {
        'Flashplayer', 'mpv', 'TempTerm', 'Xfce4-screenshooter',
        'Wine', 'shadowsocks-qt5', 'baka-mplayer' },
        name = { 'Event Tester' },
        instance = { 'QQ.exe' },
        role = { 'TempTerm', }, },
      properties = {
        floating = true,
      } },
    { rule = { role = 'browser' },
      properties = { opacity = 1 } },
    { rule = { instance = 'QQ.exe' },
      properties = { border_width = 0 } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },

    -- -- Add titlebars to normal clients and dialogs
    -- { rule_any = {type = { "normal", "dialog" }
    --   }, properties = { titlebars_enabled = true }
    -- },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup and
      not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = awful.util.table.join(
        awful.button({ }, 1, function()
            client.focus = c
            c:raise()
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            client.focus = c
            c:raise()
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
        and awful.client.focus.filter(c) then
        client.focus = c
    end
end)

-- No border for maximized clients
client.connect_signal("focus",
    function(c)
        if c.maximized then -- no borders if only 1 client visible
            c.border_width = 0
        elseif #awful.screen.focused().clients > 1 then
            c.border_width = beautiful.border_width
            c.border_color = beautiful.border_focus
        end
        c.opacity = 1
    end)
client.connect_signal("unfocus",
    function(c) 
        c.border_color = beautiful.border_normal 
        c.opacity = 0.8
    end)
-- }}}

-- {{{ collect orphan process (by lilydjwg)
pcall(function()
    package.cpath = package.cpath .. ';/home/leoliu/playground/clua/?.so'
    local clua = require('clua')
    clua.setsubreap(true)
    clua.ignore_SIGCHLD()
    local pid = 1
    while pid > 0 do
        _, pid = clua.reap()
    end
end)
-- }}}

-- {{{ autostart
c_util.run_once("xcompmgr &")
c_util.run_once("light-locker")
c_util.run_once("nm-applet")
c_util.run_once("fcitx -d")
awful.util.spawn("/usr/bin/setxkbmap -option caps:super")
c_util.run_once("xcape -t 250 -e 'Super_L=Escape'")
-- }}}