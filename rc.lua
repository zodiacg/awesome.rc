-- library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
local wibox = require("wibox")
local beautiful = require("beautiful")
local vicious = require("vicious")
local uzful =  require('uzful')
uzful.util.patch.vicious()
local lain = require("lain")
local naughty = require("naughty")
local menubar = require("menubar")
local c_util = require("c_util")

-- for fcitx-chttrans
table.insert(naughty.config.icon_dirs, '/usr/share/icons/hicolor/48x48/apps/')
table.insert(naughty.config.icon_dirs, '/usr/share/icons/hicolor/48x48/status/')

-- load my applications menu
local appmenu = require("menu")

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
                         text = err })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
beautiful.init(os.getenv("HOME") .. "/.config/awesome/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "xfce4-terminal"
editor = "atom" or "nvim" or os.getenv("EDITOR") or "editor"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts =
{
    awful.layout.suit.floating,
    lain.layout.uselesstile,
    lain.layout.uselesstile.left,
    lain.layout.uselesstile.bottom,
    lain.layout.termfair,
    lain.layout.centerwork,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier
}
lain.layout.termfair.nmaster = 2
lain.layout.termfair.ncol = 1
-- }}}

-- {{{ Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags_name = { "1E", "2V", "3Web", "4Term", "5QQ", "6MPV", "7", "8", "9", '0' }
tags_layout = {
    lain.layout.uselesstile,
    lain.layout.uselesstile,
    awful.layout.suit.max,
    lain.layout.termfair,
    awful.layout.suit.floating,
    lain.layout.uselesstile,
    lain.layout.uselesstile,
    lain.layout.uselesstile,
    lain.layout.uselesstile,
    awful.layout.suit.floating,
}
tags = {}
revtags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag(tags_name, s, tags_layout)
    revtags[s] = {}
    for i, t in ipairs(tags[s]) do
        revtags[s][t] = i
    end
end
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
m_awesome = {
  { "编辑配置 (&E)", editor .. " " .. awesome.conffile },
  { "重新加载 (&R)", awesome.restart, '/usr/share/icons/elementary-xfce/actions/16/reload.png' },
  { "Session注销 (&U)", "xfce4-session-logout"},
  { "注销 (&L)", awesome.quit },
}

m_main = awful.menu({ items = {
    { "&Awesome", m_awesome, beautiful.awesome_icon },
    { "Thunar (&F)", "thunar ", "/usr/share//icons/hicolor/16x16/apps/Thunar.png" },
    { "&Google Chrome", "google-chrome-unstable", "/usr/share/icons/hicolor/16x16/apps/google-chrome-unstable.png"},
    { "&Shadowsocks-Qt5", "ss-qt5" },
    { "A&ndroid Studio", "\"/home/leoliu/AndroidSDK/android-studio/bin/studio.sh\" ", "///home/leoliu/AndroidSDK/android-studio/bin/studio.png" },
    { "终端 (&T)", "xfce4-terminal"},
    { "应用程序 (&P)", xdgmenu(terminal) },
    { "锁屏 (&L)", "light-locker-command -l", "/usr/share/icons/elementary-xfce/actions/16/lock.png"},
    { "注销 (&O)", awesome.quit },
    { "重启 (&R)", "zenity --question --title '重启' --text '你确定重启吗？' --default-cancel && systemctl reboot", '/usr/share/icons/elementary-xfce/actions/16/reload.png' },
    { "关机 (&H)", "zenity --question --title '关机' --text '你确定关机吗？' --default-cancel && systemctl poweroff", '/usr/share/icons/elementary-xfce/actions/16/gtk-quit.png' },
}})

w_launcher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = m_main })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Widgets and Panels
markup = lain.util.markup

-- Create a textclock widget with calendar
w_textclock = awful.widget.textclock("%m月%d日 %H:%M %A", 1)
w_cal = uzful.widget.calendar({
    all = '<span size="small">$1</span>',
    head = '<span color="#666666">$1</span>',
    week = '<span color="#999999">$1</span>',
    day  = '<span color="#BBBBBB">$1</span>',
    number  = '<span color="#EEEEEE">$1</span>',
    current = '<span color="green">$1</span>',
})
w_textclock:buttons(awful.util.table.join(
    awful.button({         }, 1, function()  w_cal:switch_month(-1)  end),
    awful.button({         }, 2, function()  w_cal:now()             end),
    awful.button({         }, 3, function()  w_cal:switch_month( 1)  end),
    awful.button({         }, 4, function()  w_cal:switch_month(-1)  end),
    awful.button({         }, 5, function()  w_cal:switch_month( 1)  end),
    awful.button({ 'Shift' }, 1, function()  w_cal:switch_year(-1)  end),
    awful.button({ 'Shift' }, 2, function()  w_cal:now()             end),
    awful.button({ 'Shift' }, 3, function()  w_cal:switch_year( 1)  end),
    awful.button({ 'Shift' }, 4, function()  w_cal:switch_year(-1)  end),
    awful.button({ 'Shift' }, 5, function()  w_cal:switch_year( 1)  end)
))
w_infobox = {}
w_infobox.cal = uzful.widget.infobox({
        size = function () return w_cal.width,w_cal.height end,
        position = "top", align = "right",
        widget = w_cal.widget })
w_textclock:connect_signal("mouse::enter", function ()
    w_cal:update()
    w_infobox.cal:update()
    w_infobox.cal:show()
end)
w_textclock:connect_signal("mouse::leave", w_infobox.cal.hide)

-- Volume
w_volume = lain.widgets.alsa({
    settings = function()
        if volume_now.status == "off" then
            widget:set_text(" M ")
        else
            widget:set_text(" " .. volume_now.level .. "% ")
        end
    end
})
w_volume:buttons(awful.util.table.join(
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

-- Uptime
w_uptime = wibox.widget.textbox()
vicious.register(w_uptime, vicious.widgets.uptime,
    function (widget, args)
        return string.format(" %2dd %02d:%02d ", args[1], args[2], args[3])
    end, 61)

-- Memory & swap
w_mem = wibox.widget.textbox()
vicious.register(w_mem, vicious.widgets.mem,
    function (widget, args)
        return string.format(" %dMbF/%dMbT S:%dM", args[2], args[3], args[6])
    end, 8)

-- CPU
w_cpu = lain.widgets.cpu({
    settings = function()
        widget:set_text(" CPU:" .. cpu_now.usage .. "% ")
    end
})

-- Network
w_net = lain.widgets.net({
    settings = function()
        widget:set_markup(markup("#7AC82E", " " .. net_now.received)
                          .. "K " ..
                          markup("#46A8C3", " " .. net_now.sent .. "K "))
    end
})

-- uzful layout menu
w_layoutmenu = uzful.menu.layouts(layouts)

b_top = {}
b_bottom = {}
ws_promptbox = {}
ws_layoutbox = {}
ws_taglist = {}
ws_tasklist = {}
ws_taglist.buttons = awful.util.table.join(
                     awful.button({ }, 1, awful.tag.viewonly),
                     awful.button({ modkey }, 1, awful.client.movetotag),
                     awful.button({ }, 3, awful.tag.viewtoggle),
                     awful.button({ modkey }, 3, awful.client.toggletag),
                     awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                     awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
                     )

ws_tasklist.buttons = awful.util.table.join(
                      awful.button({ }, 1, function (c)
                                               if c == client.focus then
                                                   c.minimized = true
                                               else
                                                   -- Without this, the following
                                                   -- :isvisible() makes no sense
                                                   c.minimized = false
                                                   if not c:isvisible() then
                                                       awful.tag.viewonly(c:tags()[1])
                                                   end
                                                   -- This will also un-minimize
                                                   -- the client, if needed
                                                   client.focus = c
                                                   c:raise()
                                               end
                                           end),
                      awful.button({ }, 3, function ()
                                               if instance then
                                                   instance:hide()
                                                   instance = nil
                                               else
                                                   instance = awful.menu.clients({
                                                       theme = { width = 250 }
                                                   })
                                               end
                                           end),
                      awful.button({ }, 4, function ()
                                               awful.client.focus.byidx(1)
                                               if client.focus then client.focus:raise() end
                                           end),
                      awful.button({ }, 5, function ()
                                               awful.client.focus.byidx(-1)
                                               if client.focus then client.focus:raise() end
                                           end))

-- create panels for every screen
for s = 1, screen.count() do
    -- Create a promptbox for each screen
    ws_promptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    ws_layoutbox[s] = awful.widget.layoutbox(s)
    ws_layoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 2, function () w_layoutmenu:toggle() end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    ws_taglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, ws_taglist.buttons)

    -- Create a tasklist widget
    ws_tasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, ws_tasklist.buttons)

    -- Create the wibox
    b_top[s] = awful.wibox({ position = "top", screen = s })
    b_bottom[s] = awful.wibox({ position = "bottom", screen = s})

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(w_launcher)
    left_layout:add(ws_taglist[s])
    left_layout:add(ws_promptbox[s])

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    right_layout:add(w_net)
    right_layout:add(w_cpu)
    right_layout:add(w_mem)
    right_layout:add(w_uptime)
    right_layout:add(w_volume)
    if s == 1 then right_layout:add(wibox.widget.systray()) end
    right_layout:add(w_textclock)
    right_layout:add(ws_layoutbox[s])

    -- Now bring it all together (with the tasklist in the middle)
    local up_layout = wibox.layout.align.horizontal()
    up_layout:set_left(left_layout)
    up_layout:set_right(right_layout)

    local bottom_layout = wibox.layout.align.horizontal()
    bottom_layout:set_left(ws_tasklist[s])

    b_top[s]:set_widget(up_layout)
    b_bottom[s]:set_widget(bottom_layout)
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () m_main:toggle() end),
    awful.button({ }, 4, awful.tag.viewprev),
    awful.button({ }, 5, awful.tag.viewnext)
))
-- }}}

-- {{{ Key bindings

local keynumber_reg = function (i, which)
    if not which then
        which = i
    end
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, i,
            function ()
                local screen = mouse.screen
                if tags[screen][which] then
                    awful.tag.viewonly(tags[screen][which])
                end
            end),
        awful.key({ modkey, "Control" }, i,
            function ()
                local screen = mouse.screen
                if tags[screen][which] then
                    awful.tag.viewtoggle(tags[screen][which])
                end
            end),
        awful.key({ modkey, "Shift"   }, i,
            -- 移动窗口后跳转过去
            function ()
                if client.focus and tags[client.focus.screen][which] then
                    awful.client.movetotag(tags[client.focus.screen][which])
                end
                local screen = mouse.screen
                if tags[screen][which] then
                    awful.tag.viewonly(tags[screen][which])
                end
            end),
        awful.key({ modkey, "Mod1"   }, i,
            -- 只移动窗口，不跳转过去
            function ()
                if client.focus and tags[client.focus.screen][which] then
                    awful.client.movetotag(tags[client.focus.screen][which])
                end
            end),
        awful.key({ modkey, "Control", "Shift" }, i,
            function ()
                if client.focus and tags[client.focus.screen][which] then
                    awful.client.toggletag(tags[client.focus.screen][which])
                end
            end))
end

globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () m_main:show() end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey,           }, "Return",
            function ()
                -- Go and find a terminal for me
                c_util.run_or_raise("xfce4-terminal --role=TempTerm --geometry=100x35+343+180", { role = "TempTerm" })
            end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Control"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),
    awful.key({ modkey, "Control" }, "n", awful.client.restore),

    -- Prompt
    awful.key({ modkey            }, "r",     function () ws_promptbox[mouse.screen]:run() end),
    awful.key({ "Mod1"            }, "F2",    function () ws_promptbox[mouse.screen]:run() end),

    awful.key({ modkey            }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  ws_promptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end),
    -- Menubar
    awful.key({ modkey, "Mod1"    }, "p", function() menubar.show() end),

    -- Non-empty tag browsing
    awful.key({ modkey,           }, "p", function() lain.util.tag_view_nonempty(-1) end ),
    awful.key({ modkey,           }, "n", function() lain.util.tag_view_nonempty(1) end ),

    -- screenshot
    awful.key({ "Control", "Mod1" }, "a", function() awful.util.spawn("xfce4-screenshooter") end),

    -- Alt-Tab
    awful.key({ "Mod1",           }, "Tab",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ "Mod1",  "Shift"  }, "Tab",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),

    -- program shortcuts
    awful.key({ "Control", "Mod1", "Shift" }, "x", function () awful.util.spawn("xkill") end),
    awful.key({ "Control", "Mod1"          }, "t", function () awful.util.spawn(terminal) end),
    awful.key({ modkey,    "Shift"         }, "Return",
        function ()
            awful.util.spawn("xfce4-terminal --role=TempTerm --geometry=80x24+343+180")
        end),

    -- My floating windows -> tag10
    awful.key({ modkey,           }, "q",
        function ()
            local c = client.focus
            if not c then return end
            if c.role == 'FullScreenHtop' or c.role == 'TempTerm' then
                awful.client.movetotag(tags[mouse.screen][10], c)
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
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey, "Shift"   }, "m",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

do
    local keynumber = math.min(9, #tags[1]);
    for i = 1, keynumber do
        keynumber_reg(i)
    end
    if #tags[1] >= 10 then
        keynumber_reg(0, 10)
    end
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, function (c) awful.mouse.client.resize(c, "bottom_right") end))

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
                     buttons = clientbuttons } },
    { rule_any = { class = {
        'Flashplayer', 'mpv', 'TempTerm', 'Xfce4-screenshooter',
        'Wine', 'shadowsocks-qt5' },
        name = { 'Event Tester' },
        instance = { 'QQ.exe' },
        role = { 'TempTerm', }, },
      properties = {
        floating = true,
      } },
    { rule = { instance = 'QQ.exe' },
      properties = { border_width = 0 } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end

    local titlebars_enabled = false
    if (c.class == "Wine") then titlebars_enabled = false end
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
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

        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.iconwidget(c))
        left_layout:buttons(buttons)

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
--        right_layout:add(awful.titlebar.widget.stickybutton(c))
--        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local middle_layout = wibox.layout.flex.horizontal()
        local title = awful.titlebar.widget.titlewidget(c)
        title:set_align("center")
        middle_layout:add(title)
        middle_layout:buttons(buttons)

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(middle_layout)

        awful.titlebar(c):set_widget(layout)
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- {{{ autostart
c_util.run_once("xcompmgr &")
c_util.run_once("light-locker")
c_util.run_once("nm-applet")
awful.util.spawn("/usr/bin/setxkbmap -option caps:super")
c_util.run_once("xcape -t 250 -e 'Super_L=Escape'")
-- }}}
