local colors = require("colors")
local icons = require("icons")
local settings = require("settings")

local timer_presets = {
    { label = "00:00:05", secs = 5 },
    { label = "00:03:00", secs = 180 },
    { label = "00:05:00", secs = 300 },
    { label = "00:15:00", secs = 900 },
    { label = "00:25:00", secs = 1500 },
    { label = "00:45:00", secs = 2700 },
    { label = "01:00:00", secs = 3600 },
    { label = "01:30:00", secs = 5400 },
    { label = "02:00:00", secs = 7200 },
}

local TIMER_PLACEHOLDER_LABEL = "??:??:??"

local RESET_TIMER_SCRIPT = "~/.config/sketchybar/plugins/reset_timer.sh"
local TIMER_SCRIPT = "python3 ~/.config/sketchybar/plugins/timer.py"

sbar.add("event", "reset_timer")

local timer = sbar.add("item", "timer", {
    position = "right",
    icon = {
        string = icons.timer.hour_glass.off,
        color = colors.white,
    },
    label = {
        color = colors.grey,
        highlight_color = colors.white,
        string = TIMER_PLACEHOLDER_LABEL
    },
    popup = {
        align = "center",
    },
})

local timer_bracket = sbar.add("bracket", { timer.name }, {
    background = {
        color = colors.transparent,
        border_color = colors.bg2,
    },
})

local timer_stopwatch = sbar.add("item", {
    position = "popup." .. timer.name,
    icon = {
        string = icons.timer.stop_watch,
        align = "center"
    },
    label = {
        string = "Stopwatch",
        width = 100,
        align = "center"
    },
})
timer_stopwatch:subscribe("mouse.clicked", function(env)
    timer:set({
        popup = {
            drawing = "toggle"
        },
        icon = {
            string = icons.timer.stop_watch,
            color = colors.blue,
        },
    })
    sbar.exec(TIMER_SCRIPT)
end)

for _, timer_preset in pairs(timer_presets) do
    local timer_preset_item = sbar.add("item", {
        position = "popup." .. timer.name,
        icon = {
            string = icons.timer.hour_glass.on,
            align = "center"
        },
        label = {
            string = timer_preset.label,
            width = 100,
            align = "center"
        },
    })
    timer_preset_item:subscribe("mouse.clicked", function(env)
        sbar.exec(TIMER_SCRIPT .. " " .. timer_preset.secs)
        timer:set({
            popup = {
                drawing = "toggle"
            },
            icon = {
                string = icons.timer.hour_glass.on,
                color = colors.blue,
            },
        })
    end)
end

timer:subscribe("mouse.clicked", function(env)
    local drawing = timer:query().popup.drawing
    local label = timer:query().label.value
    if drawing == "off" and label ~= TIMER_PLACEHOLDER_LABEL then
        sbar.exec(RESET_TIMER_SCRIPT)
        timer:set({
            icon = {
                string = icons.timer.hour_glass.off,
                color = colors.white,
            },
            label = {
                string = TIMER_PLACEHOLDER_LABEL,
                color = colors.grey,
            },
        })
    else
        timer:set({
            popup = {
                drawing = "toggle"
            }
        })
    end
end)