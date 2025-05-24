local widget = require("astal.gtk3.widget")
local anchor = require("astal.gtk3").Astal.WindowAnchor
local astal = require("astal")

local GLib = astal.require("GLib")
local variable = astal.Variable
local bind = astal.bind
local battery = astal.require("AstalBattery")
local hyprland = astal.require("AstalHyprland")

function time()
  local time = variable(""):poll(1000, function()
		return GLib.DateTime.new_now_local():format("%H:%M - %A %e.")
	end)

	return widget.Label({
		class_name = "Time",
		on_destroy = function()
			time:drop()
		end,
		label = time(),
	})
end

function battery_box()
	local bat = battery.get_default()

	return widget.Box({
    halign = "END",
		class_name = "Battery",
		visible = bind(bat, "is-present"),
		widget.Icon({
			icon = bind(bat, "battery-icon-name"),
		}),
		widget.Label({
			label = bind(bat, "percentage"):as(function(p)
				return tostring(math.floor(p * 100)) .. " %"
			end),
		}),
	})
end

function workspace()
	local hypr = hyprland.get_default()
  local focused = bind(hypr, "focused-workspace")

	return widget.Box({
    halign = "START",
	  class_name = "Focused",
	  visible = focused,
	  focused:as(function(client)
	  return client and widget.Label({
	    label = bind(client, "id"):as(function(v)
        return "[" .. tostring(math.tointeger(v-1)) .. "]"
      end),
	  })
	  end),
	})
end

return function(monitor)
    return widget.Window({
        monitor = monitor,
        anchor = anchor.TOP + anchor.LEFT + anchor.RIGHT,
        exclusivity = "EXCLUSIVE",
        widget.CenterBox({
          workspace(),
          time(),
          widget.Box({
            halign = "END",
            children = {
              battery_box()
            },
          }),
        })
    })
  end
