--      ████████╗ ██████╗ ██████╗     ██████╗  █████╗ ███╗   ██╗███████╗██╗
--      ╚══██╔══╝██╔═══██╗██╔══██╗    ██╔══██╗██╔══██╗████╗  ██║██╔════╝██║
--         ██║   ██║   ██║██████╔╝    ██████╔╝███████║██╔██╗ ██║█████╗  ██║
--         ██║   ██║   ██║██╔═══╝     ██╔═══╝ ██╔══██║██║╚██╗██║██╔══╝  ██║
--         ██║   ╚██████╔╝██║         ██║     ██║  ██║██║ ╚████║███████╗███████╗
--         ╚═╝    ╚═════╝ ╚═╝         ╚═╝     ╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝╚══════╝

-- ===================================================================
-- Initialization
-- ===================================================================

local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local gears = require("gears")
local dpi = beautiful.xresources.apply_dpi

-- import widgets
local task_list = require("widgets.task-list")

-- define module table
local top_panel = {}

top_panel.create = function(s, offset)

   local offsetx = 0
	if offset == true then
		offsetx = dpi(45)
   end
   
   local panel = awful.wibar({
      ontop = true,
      screen = s,
      type = 'dock',
      height = dpi(25),
      width = s.geometry.width - offsetx,
      x = s.geometry.x + offsetx,
      y = s.geometry.y,
      stretch = false,
      bg = beautiful.background,
      fg = beautiful.fg_normal
   })

   panel:struts
   {
      top = dpi(25)
   }

   panel : connect_signal(
		'mouse::enter',
		function() 
			local w = mouse.current_wibox
			if w then
				w.cursor = 'left_ptr'
			end
		end
   )
   
   s.systray = wibox.widget {
		visible = false,
		base_size = dpi(20),
		horizontal = true,
		screen = 'primary',
		widget = wibox.widget.systray
   }

   local clock 			= require('widgets.clock')(s)
   local layout_box 		= require('widgets.layoutbox')(s)
   s.tray_toggler  		= require('widgets.tray-toggle')
	s.updater 				= require('widgets.package-updater')()
	--s.screen_rec 			= require('widgets.screen-recorder')()
	--s.mpd       			= require('widgets.mpd')()
	--s.bluetooth   			= require('widgets.bluetooth')()
	--s.battery     			= require('widgets.battery')()
	s.network       		= require('widgets.network')()
	s.info_center_toggle	= require('widgets.info-center-toggle')()

   panel : setup
   {
      layout = wibox.layout.align.horizontal,
      expand = 'none',
		{
			layout = wibox.layout.fixed.horizontal,
			task_list(s),
			add_button
      },
      clock,
      {
			layout = wibox.layout.fixed.horizontal,
			spacing = dpi(5),
			{
				s.systray,
				margins = dpi(5),
				widget = wibox.container.margin
			},
         layout_box,
         s.info_center_toggle,
         s.updater,
         s.network,
         s.tray_toggler         
		}
   }

   -- hide panel when client is fullscreen
   client.connect_signal('property::fullscreen',
      function(c)
         panel.visible = not c.fullscreen
      end
   )

   return panel
end

return top_panel
