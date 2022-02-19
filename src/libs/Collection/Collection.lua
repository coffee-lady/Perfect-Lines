local Collection = class('Array')

function Collection:initialize(...)
	local params = {...}
	local params_len = #params

	self.items = {}
	self.index = 0

	if params_len == 1 then
		local n = params[1]
		local param_type = type(n)
		if param_type == 'number' then
			self.items = {}
			self.index = 0
			for i = 1, n do
				Collection.push(self, true)
			end
		end
	end
end

function Collection:push(value)
	local index = self.index + 1
	self.items[index] = value
	self.index = index
end

function Collection:pop()
	local index = self.index
	local pop_val = self.items[index]
	self.index = index - 1
	return pop_val
end

function Collection:length()
	return self.index
end

function Collection:at(ind)
	return self.items[ind]
end

function Collection:set(ind, value)
	self.items[ind] = value
	local index = self.index
	if ind > index then
		self.index = ind
	end
end

function Collection:index_of(value)
	for i = 1, self.index do
		if self.items[i] == value then
			return i
		end
	end

	return nil
end

function Collection:remove_at(ind)
	local items = self.items
	local index = self.index
	for i = ind + 1, index do
		items[i - 1] = items[i]
	end
	self.index = index - 1
end

function Collection:remove(value)
	local value_index = Collection.index_of(self, value)
	if value_index ~= nil then
		self:remove_at(value_index)
	end
end

function Collection:remove_fn(fn_condition)
	assert(fn_condition)
	assert(type(fn_condition) == 'function')

	local removed = {}
	local removed_index = 0

	local shift = 0

	local index = self.index
	local items = self.items

	for i = 1, index do
		local val = items[i]
		if not fn_condition(val) then
			removed_index = removed_index + 1
			removed[removed_index] = val
			shift = shift + 1
		else
			if shift > 0 then
				items[i - shift] = items[i]
			end
		end
	end

	self.index = index - shift

	return removed
end

function Collection:clear()
	self.index = 0
end

function Collection:contain(value)
	local ind = Collection.index_of(self, value)
	return ind ~= nil
end
function Collection:copy()
	local res = Collection:new()
	for i = 1, self.index do
		res:push(self.items[i])
	end
	return res
end

local function default_selector()
	return true
end

local function select_one(items, selector, index_start, index_end)
	assert(type(selector) == 'function')
	local step = index_start < index_end and 1 or -1

	for i = index_start, index_end, step do
		local item = items[i]
		if selector(item) then
			return item
		end
	end

	return nil
end

function Collection:first(selector)
	local items = self.items

	if not selector then
		return items[1]
	end

	return select_one(self.items, selector, 1, self.index)
end

function Collection:last(selector)
	local items = self.items

	if not selector then
		return items[self.index]
	end

	return select_one(self.items, selector, self.index, 1)
end

function Collection:select(selector)
	if not selector then
		return self:copy()
	end

	assert(type(selector) == 'function', 'wrong selector type ')

	local res = Collection:new()

	for i = 1, self.index do
		local item = self.items[i]
		if selector(item) then
			res:push(item)
		end
	end
	return res
end

return Collection
