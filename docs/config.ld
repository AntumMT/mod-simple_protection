-- This configuration requires a modified version of LDoc found at https://github.com/AntumDeluge/LDoc/tree/antum

title = 'Simple Protection mod for Minetest'
project = 'Simple Protection'
description = "Mod that allows players to claim & protect areas."
format = 'markdown'
add_language_extension('ldoc', 'lua')
not_luadoc = true
wrap = true
output = 'api'
readme = 'README.md'


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


--- Handles "cparam" tag.
local function cparam_handler(value)
	value = string.split(value, ' ')
	local p = '<b>' .. value[1]:gsub("^%s*(.-)%s*$", "%1") .. '</b>'
	table.remove(value, 1)

	if table.len(value) then
		local d = table.concat(value, ' ')
		p = p .. ': ' .. d
	end

	return p
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

--- Handles "settype" tag.
local function settype_handler(value)
	return '<i>' .. value '</i>'
end

--- Retrieves an image to display.
--
-- @function get_image
-- @param name Base filename for image
-- @return An HTML image source
local function get_image(name)
	--local texture = '<img src="../../textures/' .. name .. '.png" style="width:32px;height:32px;" />'
	local texture = '<img src="https://raw.githubusercontent.com/AntumMT/mod-simple_protection/gh-pages/textures/' .. name .. '.png" style="width:32px;height:32px;" />'
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
	if item.tags.cparam ~= nil then
		for i, p in ipairs(item.tags.cparam) do
			p = string.split(p, ' ')[1]:gsub("^%s*(.-)%s*$", "%1")
			local left = ' ['
			local right = ']'
			if item.tags.rcparam ~= nil then
				left = ' &lt;'
				right = '&gt;'
			end
			output = output .. left .. p .. right
		end
	end
	--[[
	if item.tags.rcparam ~= nil then
		for i, p in ipairs(item.tags.rcparam) do
			output = output .. ' &lt;' .. p .. '&gt;'
		end
	end
	]]

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
	-- Optional chat command parameter
	{'cparam',
		title = 'Parameters',
		format = cparam_handler,
	},
	-- Settings type
	{'settype',
		title = 'Type',
		format = settype_handler,
	}
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
}


--- Aliases
--
-- @section aliases


alias('rcparam', 'cparam')
