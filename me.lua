local me = {}

me.status = nil
me.x = nil
me.last_x = nil
me.y = nil
me.last_y = nil
me.fast_item = nil
me.last_equipped = nil
me.name = nil
me.main_job = nil

function me:update(player)
	if player ~= nil then
		me.name = player.name
		me.main_job = windower.ffxi.get_player().main_job
		me.status = player.status
		me.last_x = me.x
		me.x = player.x
		me.last_y = me.y
		me.y = player.y
	end
end

function me:moving()
	if me.last_x == nil or me.last_y == nil or me.x == nil or me.y == nil then
		return false
	elseif me.x ~= me.last_x or me.y ~= me.last_y then
		return true
	else
		return false
	end
end

function me:get_fast_item_slot(slot)
	if me.fast_item ~= nil then
		if slot == 4 then
			return 'head'
		elseif slot == 5 then
			return 'body'
		elseif slot == 6 then
			return 'hands'
		elseif slot == 7 then
			return 'legs'
		elseif slot == 8 then
			return 'feet'
		end
	end
end

function me:set_fast_item(item)
	me.fast_item = item
end

function me:set_last_equipped_item(item)
	me.last_equipped = item
end

function me:get_currently_equipped_item()
	local slot = me:get_fast_item_slot(me.fast_item.slot)
	local armor = windower.ffxi.get_items().equipment[slot]
	local gear = windower.ffxi.get_items(windower.ffxi.get_items().equipment[slot..'_bag'],windower.ffxi.get_items().equipment[slot])
	local item = res.items:with('id',gear.id)
	if item ~= nil then
		return item
	end
end

function me:equip_item(item)
	windower.ffxi.set_equip(item.inv_id, item.slot, item.bag)
end

return me