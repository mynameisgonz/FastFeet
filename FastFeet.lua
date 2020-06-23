_addon.name    = 'Fast Feet'
_addon.author  = 'Batcher of Asura'
_addon.version = '1.0'
_addon.commands = {'FastFeet','fastfeet','FF','ff'}

res = require('resources')
config = require('config')
require('equip')

-- basic config defaults
defaults = {}
defaults.characters = {}
settings = config.load(defaults)

local me = require('me')

started = false
windower.register_event('load', function()
	if windower.ffxi.get_info().logged_in then
		started = true
		update()
	end
end)

windower.register_event('unload', function()
	started = false
end)

windower.register_event('login', function(name)
	if started == false then
		started = true
		update()
	end
end)

windower.register_event('logout', function(name)
	started = false
end)

windower.register_event('addon command', function(...)
	local args = T{...}
	
	local cmd = table.remove(args,1):lower()
	
	if args ~= nil then
		-- the latest information about the character
		local p = windower.ffxi.get_player()
			
		if cmd == 'set' then				
			-- does the xml node for the character exist? if not, create
			if settings.characters[string.lower(p.name)] == nil then
				settings.characters[string.lower(p.name)] = {}
				settings:save('all')
			end
			
			-- does the xml node for the job exist? if not, create
			if settings.characters[string.lower(p.name)][string.lower(p.main_job)] == nil then
				settings.characters[string.lower(p.name)][string.lower(p.main_job)] = {}
				settings:save('all')
			end
			
			-- does the xml node for the status toggle exist? if not, create
			if settings.characters[string.lower(p.name)][string.lower(p.main_job)].engaged == nil then
				settings.characters[string.lower(p.name)][string.lower(p.main_job)].engaged = true
				settings:save('all')
			end
			
			if args[1] ~= nil or args[1] ~= "" then
				if search_item(args[1]) then
					settings.characters[string.lower(p.name)][string.lower(p.main_job)].item = args[1]
					log('Fast Item set to ' .. args[1] .. ' for ' .. p.name .. ' on ' .. p.main_job)
					settings:save('all')
				else
					log('could not find item')
				end
			end
		elseif cmd == 'engaged' then
			if settings.characters[string.lower(p.name)][string.lower(p.main_job)].engaged then
				settings.characters[string.lower(p.name)][string.lower(p.main_job)].engaged = false
				log('Item swap in combat set to false')
				settings:save('all')
			else
				settings.characters[string.lower(p.name)][string.lower(p.main_job)].engaged = true
				log('Item swap in combat set to true')
				settings:save('all')
			end
		end
	end
end)

function update()
	if started then
		-- keep running this function
		coroutine.schedule(update,0.2)
		
		me:update(windower.ffxi.get_mob_by_target('me'))
		
		if check_fast_item() then
			if me:moving() and checkCombat() then
				--me:equip_item(me.fast_item)
				local equipped = me:get_currently_equipped_item()
				
				--save the previously equipped item
				check_current_equip_item(equipped)
				
				if equipped and equipped.en ~= me.fast_item.name then
					me:equip_item(me.fast_item)
				end
			else
				local equipped = me:get_currently_equipped_item()
				
				if equipped ~= nil and me.last_equipped ~= nil and equipped.en ~= me.last_equipped.name then
					me:equip_item(me.last_equipped)
				end
			end
		end
	end
end

function checkCombat()
	if settings.characters[string.lower(me.name)][string.lower(me.main_job)].engaged then
		if me.status == 1 then
			return false
		else
			return true
		end
	else
		return true
	end
end

function check_fast_item()
	if settings.characters[string.lower(me.name)] == nil or settings.characters[string.lower(me.name)][string.lower(me.main_job)] == nil or settings.characters[string.lower(me.name)][string.lower(me.main_job)].item == nil then
		return false
	else
		local armor = settings.characters[string.lower(me.name)][string.lower(me.main_job)].item
		local item = res.items:with('en',armor)

		local found = false
		
		if item ~= nil then
			for index,i in ipairs(windower.ffxi.get_items('inventory')) do
				if i.id == item.id then
					found = true
					local e = equip:new(item,i,index,0)
					me:set_fast_item(e)
				end
			end
			
			for index,i in ipairs(windower.ffxi.get_items('wardrobe')) do
				if i.id == item.id then
					found = true
					local e = equip:new(item,i,index,8)
					me:set_fast_item(e)
				end
			end
			
			for index,i in ipairs(windower.ffxi.get_items('wardrobe2')) do
				if i.id == item.id then
					found = true
					local e = equip:new(item,i,index,10)
					me:set_fast_item(e)
				end
			end
			
			for index,i in ipairs(windower.ffxi.get_items('wardrobe3')) do
				if i.id == item.id then
					found = true
					local e = equip:new(item,i,index,11)
					me:set_fast_item(e)
				end
			end
			
			for index,i in ipairs(windower.ffxi.get_items('wardrobe4')) do
				if i.id == item.id then
					found = true
					local e = equip:new(item,i,index,12)
					me:set_fast_item(e)
				end
			end
		end
		
		if found then
			return true
		else
			return false
		end
	end
end

function search_item(armor)
	local item = res.items:with('en',armor)

	local found = false
		
	if item ~= nil then
		for index,i in ipairs(windower.ffxi.get_items('inventory')) do
			if i.id == item.id then
				found = true
			end
		end
		
		for index,i in ipairs(windower.ffxi.get_items('wardrobe')) do
			if i.id == item.id then
				found = true
			end
		end
		
		for index,i in ipairs(windower.ffxi.get_items('wardrobe2')) do
			if i.id == item.id then
				found = true
			end
		end
		
		for index,i in ipairs(windower.ffxi.get_items('wardrobe3')) do
			if i.id == item.id then
				found = true
			end
		end
		
		for index,i in ipairs(windower.ffxi.get_items('wardrobe4')) do
			if i.id == item.id then
				found = true
			end
		end
	end
	
	if found then
		return true
	else
		return false
	end
end

function check_current_equip_item(armor)
	if armor and armor.en == me.fast_item.name then return end
	
	if armor ~= nil then
		for index,i in ipairs(windower.ffxi.get_items('inventory')) do
			if i.id == armor.id then
				local e = equip:new(armor,i,index,0)
				me:set_last_equipped_item(e)
			end
		end
		
		for index,i in ipairs(windower.ffxi.get_items('wardrobe')) do
			if i.id == armor.id then
				local e = equip:new(armor,i,index,8)
				me:set_last_equipped_item(e)
			end
		end
		
		for index,i in ipairs(windower.ffxi.get_items('wardrobe2')) do
			if i.id == armor.id then
				local e = equip:new(armor,i,index,10)
				me:set_last_equipped_item(e)
			end
		end
		
		for index,i in ipairs(windower.ffxi.get_items('wardrobe3')) do
			if i.id == armor.id then
				local e = equip:new(armor,i,index,11)
				me:set_last_equipped_item(e)
			end
		end
		
		for index,i in ipairs(windower.ffxi.get_items('wardrobe4')) do
			if i.id == armor.id then
				local e = equip:new(armor,i,index,12)
				me:set_last_equipped_item(e)
			end
		end
	end
end

function log(message)
	windower.add_to_chat(166,tostring(message))
end