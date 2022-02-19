local class = require('src.libs.tools.middleclass.middleclass')

--- @class LinkedListNode
local LinkedListNode = class('LinkedListNode')

function LinkedListNode:initialize(val)
    self.node = {}

    self.node.value = val
    self.node.next = nil
    self.node.prev = nil

    return self.node
end

function LinkedListNode:get_value()
    return self.node.value
end

return LinkedListNode
