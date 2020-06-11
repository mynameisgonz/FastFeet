equip = {}
equip._index = equip

function equip:new(i,inv,index,bag)
	local item = {}  
	setmetatable(item, equip)
	item.id = i.id
	item.name = i.en
	item.slot = tonumber(tostring(i.slots)[2])
	item.inv_id = index
	item.bag = bag
	
	return item
end