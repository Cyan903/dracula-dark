local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

local cfg = require("src.util.config")

require("awful.autofocus")

client.connect_signal("manage", function (c)
    if cfg.config.window.spawn_slave then
        if not awesome.startup then awful.client.setslave(c) end
    end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        awful.placement.no_offscreen(c)
    end
end)

-- Titlebars
client.connect_signal("request::titlebars", function(c)
    awful.titlebar(c, { position = "left", size = 30 }) : setup {
        {

            {
                {
                    {
                        {
                            awful.titlebar.widget.closebutton(c),
                            layout = wibox.layout.fixed.vertical
                        },

                        layout = wibox.container.margin,
                        bottom = 5,
                    },

                    {
                        {
                            awful.titlebar.widget.maximizedbutton(c),
                            layout = wibox.layout.fixed.vertical
                        },

                        layout = wibox.container.margin,
                        bottom = 5,
                    },

                    {
                        {
                            awful.titlebar.widget.minimizebutton(c),
                            layout = wibox.layout.fixed.vertical
                        },

                        layout = wibox.container.margin,
                        bottom = 5,
                    },

                    layout = wibox.layout.fixed.vertical
                },

                layout = wibox.container.margin,
                margins = 6,
            },

            { layout = wibox.layout.fixed.vertical },

            {
                {
                    awful.titlebar.widget.iconwidget(c),
                    layout = wibox.layout.fixed.horizontal()
                },

                layout = wibox.container.margin,
                margins = 8,
            },

            expand = "none",
            layout = wibox.layout.align.vertical,
        },

        widget = wibox.container.margin,
        margins = 1,
    }
end)

-- Sloppy focus
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal("focus", function(c)
    if c.floating then
        c.border_color = beautiful.border_normal
        return
    end

    c.border_color = beautiful.border_focus
end)

client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- Toggle titlebar when floating
local function float_toggle(c)
    if c.floating and not c.maximized then
        awful.titlebar.show(c, "left")
        c.border_color = beautiful.border_normal
    else
        awful.titlebar.hide(c, "left")
        c.border_color = beautiful.border_focus
    end

    -- Deal with maximized windows
    if c.maximized then
        c.border_color = beautiful.border_normal
    end
end

client.connect_signal("property::floating", float_toggle)
client.connect_signal("property::maximized", float_toggle)
client.connect_signal("manage", float_toggle)
