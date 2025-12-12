local ECS = require 'ecs.ecs'

---@class BunnyMoveSystem:EcsSystem
local System = ECS.CLASS.class("BunnyMoveSystem", ECS.System)
System.filter = ECS.filter("bunny")

function System.new() return ECS.CLASS.new_instance(System) end

function System:update(dt)
	local entities = self.entities_list
	for i = 1, #entities do
		local e = entities[i]
		e.velocity = e.velocity - 1200 * dt

		local p = e.position
		p.y = p.y + e.velocity * dt
		if p.y < 50 then
			p.y = 50
			e.velocity = -e.velocity
		end
	end
end

return System
