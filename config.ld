-- This configuration requires a modified version of LDoc found at https://github.com/AntumDeluge/LDoc/tree/antum

title = 'Simple Protection mod for Minetest'
project = 'Simple Protection'
description = "Mod that allows players to claim & protect areas."
format = 'markdown'
add_language_extension('ldoc', 'lua')
not_luadoc = true
style = '!fixed'
wrap = true
output = 'api'
readme = 'README.md'
dir = 'docs'
icon = 'icon.png'
file = {
	'ldoc',
}


-- Imported modules
local string = require 'string'
local table = require 'table'


--- General Functions
--
-- @section functions


--- Retrieves length of table.
function table.len(t)
	local l = 0
	for i, p in pairs(t) do
		l = l + 1
	end

	return l
end


--- Handles "recipe" tag.
local function recipe_handler(value)
	local s = string.split(value, '\n')
	local output = s[1]
	table.remove(s, 1)
	local ingredients = s

	if output ~= nil then
		local ctype
		local ccount
		if string.find(output, ',') then
			s = string.split(output, ',')
			ccount = s[1]
			ctype = s[2]
		end

		if not ccount then
			ccount = "1"
		end
		output = '<b>Count:</b> ' .. ccount

		if #ingredients > 0 then
			if ctype ~= nil then
				output = '<b>Type:</b> ' .. ctype .. '<br>' .. output
			end

			output = output .. '<br><b>Recipe:</b><br><blockquote>'

			for _, i in pairs(ingredients) do
				output = output .. string.gsub(i, '[{}"]', '')
			end

			output = output .. '</blockquote>'
		end
	end

	return output
end

--- Changes text style to italic.
local function to_italic(value)
	return '<i>' .. value .. '</i>'
end

--- Retrieves an image to display.
--
-- @function get_image
-- @param name Base filename for image
-- @return An HTML image source
local function get_image(name)
	local texture = '<img src="../../textures/' .. name .. '.png" style="width:32px;height:32px;" />'
	return texture
end


--- Type Handler Functions
--
-- @section type_handlers


--- Handles chatcmd type.
--
-- @function chatcmd_handler
-- @param item
local function chatcmd_handler(item)
	local output = item.name
	for _, P in ipairs(item.params) do
		local param = P
		local opt = item:default_of_param(P)
		local sub_params = item:subparam(P)
		if #sub_params > 0 and sub_params[1] ~= param then
			param = param .. ' ('
			for idx = 1, #sub_params, 1 do
				local subp = string.split(sub_params[idx], '.')[2]
				if idx == 1 then
					param = param .. subp
				else
					param = param .. ', ' .. subp
				end
			end
			param = param .. ')'
		end
		if opt then
			output = output .. ' [' .. param .. ']'
		else
			output = output .. ' &lt;' .. param .. '&gt;'
		end
	end

	return output
end

--- Main handler for custom types.
--
-- @function custom_display_name_handler
-- @param item
-- @param default_handler
-- @return
function custom_display_name_handler(item, default_handler)
	if item.type == 'chatcmd' then
		return chatcmd_handler(item)
	end

	return default_handler(item)
end


--- Types
--
-- @section types


-- Custom types
new_type('client', 'Client', true)
new_type('dev', 'Development', true)
new_type('chatcmd', 'Chat Commands', false, 'param')
new_type('setting', 'Settings', false)
new_type('item', 'Items', false)
new_type('priv', 'Privileges', false)
new_type('node', 'Nodes', false)


--- Tags
--
-- @section tags


-- Custom tags
custom_tags = {
	-- Settings type
	{'settype',
		title = 'Type',
		format = to_italic,
	},
	-- Item preview images
	{'img',
		title = 'Image',
		format = get_image,
	},
	-- Crafting recipes
	{'crafttype',
		title = 'Type',
	},
	{'recipe',
		title = 'Craft Recipes',
		format = recipe_handler,
	},
	{'default',
		title = 'Default Value',
		format = to_italic,
	},
}
