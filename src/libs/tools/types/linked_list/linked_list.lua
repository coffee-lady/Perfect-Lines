local class = require('src.libs.tools.middleclass.middleclass')
local Node = require('src.libs.tools.types.linked_list.node.node')

--- @class LinkedList
local LinkedList = class('LinkedList')

function LinkedList:initialize(arr)
    local tail = Node(arr[1])

    self.current = tail

    for i = 2, #arr do
        self:insert_after(tail, arr[i])
        tail = tail.next
    end
end

function LinkedList:next()
    self.current = self.current.next

    return self:get_current()
end

function LinkedList:back()
    self.current = self.current.prev

    return self:get_current()
end

function LinkedList:get_current()
    return self.current and self.current:get_value() or nil
end

function LinkedList:insert_after(node, val)
    local newnode = Node(val)

    newnode.next = node.next
    newnode.prev = node
    node.next = newnode

    return newnode
end

function LinkedList:remove(node)
    local index = node.next
    node.prev.next = node.next
    return index
end

return LinkedList
