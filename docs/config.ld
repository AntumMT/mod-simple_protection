-- This configuration requires a modified version of LDoc found at https://github.com/AntumDeluge/LDoc/tree/antum

title = 'Simple Protection mod for Minetest'
project = 'Simple Protection'
description = "Mod that allows players to claim & protect areas."
format = 'markdown'
add_language_extension('ldoc', 'lua')
not_luadoc = true
wrap = true
ignore = true
output = 'api'
readme = 'README.md'


-- Imported modules
local string = require 'string'
local table = require 'table'


--- General Functions
--
-- @section functions


--- Handles "recipe" tag.
local function recipe(value)
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

--- Retrieves an image to display.
--
-- @function getImage
-- @param name Base filename for image
-- @return An HTML image source
local function getImage(name)
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
	if item.tags.cparam ~= nil then
		for i, p in ipairs(item.tags.cparam) do
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
local function custom_display_name_handler(item, default_handler)
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
	},
	-- Item preview images
	{'img',
		title = 'Image',
		format = getImage,
	},
	-- Crafting recipes
	{'crafttype',
		title = 'Type',
	},
	{'recipe',
		title = 'Craft Recipes',
		format = recipe,
	},
}


--- Aliases
--
-- @section aliases


alias('rcparam', 'cparam')
